clc; clear;
%%
version1 = 'V10'; %% the previous version to obtain the results
version2 = 'V30'; %% the new version to save the results
Delimiter = "|";
dir.base = "C:/Users/kiana/OneDrive - University of Toronto/Projects/COVID/";
dir.data = "/data/";
dir.db = '/gisaid_hcov-19_2020_06_15_19.fasta';
dir.fastaseq = 'Seq.fasta';
loc1 = dir.base+dir.data+'Database_'+version1+'_Frames.mat'; %% database location
loc2 = dir.base+dir.data+'Database_'+version1+'_Seq.mat';
loc4 = dir.base+'PDB.fasta';

%% read covid fasta sequence
block =  CreateSequence(dir.base+dir.fastaseq);
%% Parsing the database extracted and cured from GISAID
if isfile(loc1)
    disp("Loading the database ...")
    load(loc1);
    load(loc2);
    db.FrameOne = db_a.FrameOne; db.FrameTwo = db_a.FrameTwo;db.FrameThree = db_a.FrameThree;
    db.Header = db_b.Header; db.NTSeq = db_b.NTSeq;
    clear db_a;clear db_b;
    disp("Loaded!")
else
    disp("Creating the database from fastafile...")
    disp("This might take several minutes. Please wait")
    db = CreateDatabase(dir.base+dir.data+dir.db);
    disp("removing duplicates...");
    disp("Created!")
    db_a.FrameOne = db.FrameOne;db_a.FrameTwo = db.FrameTwo;db_a.FrameThree = db.FrameThree;
    db_b.NTSeq = db.NTSeq; db_b.Header = db.Header;
    save(loc1,"db_a");
    save(loc2,"db_b");
    clear db_a; clear db_b;
    disp("saved in "+loc); 
end
[countEqu,db, indx_Equ] = CountEqual(block,db);
clear loc; clear s;

%% Pairwise Local Alignment
% creating a sample to facilitate the calculation
db_copy = db;
n = 1;
m = length(db.NTSeq);
disp("Local Alignment using database subset")
sprintf("Database size : %d %d",size(db.NTSeq))
part = input(" Do you want to consider a subset of the database? [y,n]",'s');
if part == 'y'
    n = input("Enter starting index :");
    m = input("Enter final index :");
    db_copy.FrameOne = db.FrameOne(n:m,1);
    db_copy.FrameTwo = db.FrameTwo(n:m,1);
    db_copy.FrameThree = db.FrameThree(n:m,1);
    db_copy.NTSeq = db.NTSeq(n:m,1);
    db_copy.Header = db.Header(n:m,1);
end
%% Date and Country of sampling
disp("Generating Date and Country");
db_copy = Header2DateLocation(db_copy);
%% adjusting Country and Date by their number of tests performed
f4_adj = frequencyTable(db_copy.Date);
f5_adj = frequencyTable(db_copy.Country);
%% Amino Acid Local Alignment
[db_copy2] = AalocalAlignment(block.BASeq,db_copy);
%% Delete sequences that don't have full coverage in the binding domain
[db_copy3, indx_fullCoverage] = DeleteNs(db_copy2);
%% Deleting Ordinary records
[db_copy4,countEqu] = DeleteOrdinary(db_copy3,db_copy3.Aalignment,countEqu);
%% Nucleotide Local Alignment
disp("Nucleotide Local Alignment")
[db_copy4] = NtlocalAlignment(block.BNSeq,db_copy4);
%% Spotting the mutations
disp("Spoting Mutations in the amino acid sequence");
db_copy4.AAMutation = LocateMutants(block.BASeq,db_copy4.Aalignment,loc4);
disp("Spoting Mutations in the Nucleotide sequence");
%%
db_copy4.NTMutation = LocateMutants(block.BNSeq,db_copy4.NTAlignment,'');
%%
if isempty(db_copy4.NTSeq)
    disp("No mutation found!");
    return
else
    res  = dir.base+dir.data+"Result_db_"+version2+"_"+n+"_"+m+".mat";
    sprintf("number of similar sequences: %d",countEqu);
    disp("Saving the result in "+ res);
    save(res,"db_copy4");
end
%% Remove sequences which are extremelt dissimilar to the original sequence
[db_copy4, OffNum] = ThresholdScore(db_copy4,30);
m = m - OffNum;
disp(OffNum)
%% Display frequency table of the location of mutation accured
disp("Mutation frequency in the Nucleotide Seq");
disp("Frequency table of the Location");
f0 = frequencyTable(db_copy4.NTMutation.Loc);
disp("Frequency table of the Mutation on the Given Sequence");
frequencyTable(db_copy4.NTMutation.One)
disp("Frequency table of the Mutation on the db Sequence");
frequencyTable(db_copy4.NTMutation.Two)
disp("Frequency table of the Mutation on pairs comprised on the Given Sequence and Location");
f1 = frequencyTable(MergeCells(db_copy4.NTMutation.Two,Delimiter,db_copy4.NTMutation.Loc),Delimiter);
disp(f1);
disp("Mutation frequency in the Amino Acid Seq");
disp("Frequency table of the Location");
f3 = frequencyTable(db_copy4.AAMutation.Loc);
disp("Frequency table of the Mutation on the Given Sequence");
frequencyTable(db_copy4.AAMutation.One)
disp("Frequency table of the Mutation on the db Sequence");
frequencyTable(db_copy4.AAMutation.Two)
disp("Frequency table of the Mutation on pairs comprised on the Given Sequence and Location");
f2 = frequencyTable(MergeCells(db_copy4.AAMutation.Two,Delimiter,db_copy4.AAMutation.Loc),Delimiter);
disp(f2);

%% Date and country
f4_elm = frequencyTable(db_copy4.Date);
f5_elm = frequencyTable(db_copy4.Country);

f4 = innerjoin(f4_elm,f4_adj,'LeftKeys',1,'RightKeys',1);
f5 = innerjoin(f5_elm,f5_adj,'LeftKeys',1,'RightKeys',1);

f4 = removevars(f4,{'Percent_f4_elm','Percent_f4_adj'});
f5 = removevars(f5,{'Percent_f5_elm','Percent_f5_adj'});
%%
f4.Properties.VariableNames = {'Date' 'Mutants_number' 'Total_Tests'};
f5.Properties.VariableNames = {'Country' 'Mutants_number' 'Total_Tests'};
%% Printing mutations
disp("Mutation in Nucleotide Seq");
[t1,~] = printMutation(db_copy4.NTScore ,db_copy4.NTMutation,db_copy4.Date,...
    db_copy4.Country,db_copy4.Header);
disp(t1);
disp("Mutation in Amino Acid Seq");
[t2,t3] = printMutation(db_copy4.AAScore ,db_copy4.AAMutation,db_copy4.Date,...
    db_copy4.Country,db_copy4.Header);
disp(t2);   
%%
disp("saving Results...");
% delete (dir.base+dir.data+"Mutations_"+version2+"_"+n+"_"+m+".xlsx");
writetable(t1,dir.base+dir.data+"Mutations_"+version2+"_"+n+"_"+m+".xlsx",'Sheet','Nucleotide Seq','UseExcel',false);
writetable(t2,dir.base+dir.data+"Mutations_"+version2+"_"+n+"_"+m+".xlsx",'Sheet','Amino Acid Seq','UseExcel',false);
writetable(f1,dir.base+dir.data+"Mutations_"+version2+"_"+n+"_"+m+".xlsx",'Sheet','Nucleotide Frequency','UseExcel',false);
writetable(f2,dir.base+dir.data+"Mutations_"+version2+"_"+n+"_"+m+".xlsx",'Sheet','Amino Acid Frequency','UseExcel',false);
writetable(f0,dir.base+dir.data+"Mutations_"+version2+"_"+n+"_"+m+".xlsx",'Sheet','NT Location Frequency','UseExcel',false);
writetable(f3,dir.base+dir.data+"Mutations_"+version2+"_"+n+"_"+m+".xlsx",'Sheet','AA Location Frequency','UseExcel',false);
writetable(f4,dir.base+dir.data+"Mutations_"+version2+"_"+n+"_"+m+".xlsx",'Sheet','Date Frequency','UseExcel',false);
writetable(f5,dir.base+dir.data+"Mutations_"+version2+"_"+n+"_"+m+".xlsx",'Sheet','Country Frequency','UseExcel',false);

disp("done!");

%%