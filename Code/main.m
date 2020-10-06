% flag == 0 only the NT sequences are available!
% flag == 1 the reading frames are generated!
% flag ==2 Alignment results are generated!
clc;
setDirectories
global version Delimiter dirc fasta flag m n;
%% read Input fasta files: Given Sequence and Given database
block =  CreateSequence(fasta.fastaseq);
% flag =0;
%% Curated data alreaady exists?
if flag == 2
    disp("Curated data already exists");
    comment = sprintf("the starting sequence is %d and the end sequence is %d",n,m);
    disp(comment);
    part = input("Continue? [y,n]",'s');
    if part == 'n'
        flag =1;
    end
end
%% Load the database
db = CreateDatabase();
%% Control of variables
if flag == 1 
        %% check for subset consideration
        comment = sprintf("Gisaid Database size : %d by %d",n,m);
        fprintf(comment);
        part = input("\nConsider a subset of the database for alignment? [y,n]",'s');
        
        if part == 'y'
            n = input("Enter starting index :");
            m = input("Enter final index :");
            db.FrameOne = db.FrameOne(n:m,1);
            db.FrameTwo = db.FrameTwo(n:m,1);
            db.FrameThree = db.FrameThree(n:m,1);
            db.NTSeq = db.NTSeq(n:m,1);
            db.Header = db.Header(n:m,1);
        end
    [countEqu,db, indx_Equ] = CountEqual(block,db);
    
    disp("Extracting Date and Country of the reported Sequences");
    db = Header2DateLocation(db);
    
    % Calculating the total number of tests performed at each Date and
    % Country
    T_tot_date = frequencyTable(db.Date);
    T_tot_country = frequencyTable(db.Country);
    
    % Amino Acid Local Alignment
    disp("Aligning Amino Acid Sequences")
    db = AalocalAlignment(block.BASeq,db);
    % Delete sequences that don't have full coverage in the binding domain
    [db, indx_fullCoverage] = DeleteNs(db);
    % Deleting Ordinary records
    [db,countEqu] = DeleteOrdinary(db,db.Aalignment,countEqu);
    
    % Nucleotide Local Alignment
    disp("Aligning Nucleotide sequences ... ")
    db = NtlocalAlignment(block.BNSeq,db);
    
    % Spotting the mutations
    disp("Spoting Mutations in the amino acid sequence");
    db.AAMutation = LocateMutants(block.BASeq,db.Aalignment);
    
    disp("Spoting Mutations in the Nucleotide sequence");
    db.NTMutation = LocateMutants(block.BNSeq,db.NTAlignment);
    
    comment = sprintf("number of similar sequences: %d",countEqu);
    fprintf(comment);
    
    res  = dirc.Output+"\Result_db_"+version.Output+"_"+n+"_"+m+".mat";
    disp("Saving the result in "+ res);
    save(res,"db");
    flag = 2;
elseif flag == 2 %% load the original data to normalize frequency
    flag = 1;
    db_norm = CreateDatabase();
    
    disp("Extracting Date and Country of the reported Sequences");
    db_norm = Header2DateLocation(db_norm);
    
    % Calculating the total number of tests performed at each Date and
    % Country
    ft_date_tot = frequencyTable(db_norm.Date);
    ft_country_tot = frequencyTable(db_norm.Country);
    clear db_norm
end

% Remove sequences which are extremelt dissimilar to the original sequence
[db, OffNum] = ThresholdScore(db,30);
disp(OffNum)

disp("Analyzing Identified Mutations ...");
ft_NT_loc = frequencyTable(db.NTMutation.Loc);
ft_AA_loc = frequencyTable(db.AAMutation.Loc);

ft_NT_seq_loc = frequencyTable(MergeCells(db.NTMutation.Two,Delimiter,...
    db.NTMutation.Loc),Delimiter);
ft_AA_seq_loc = frequencyTable(MergeCells(db.AAMutation.Two,Delimiter,...
    db.AAMutation.Loc),Delimiter);

ft_date = frequencyTable(db.Date);
ft_country = frequencyTable(db.Country);

ft_date_norm = innerjoin(ft_date,ft_date_tot,'LeftKeys',1,'RightKeys',1);
ft_country_norm = innerjoin(ft_country,ft_country_tot,'LeftKeys',1,'RightKeys',1);

ft_date_norm = removevars(ft_date_norm,{'Percent_ft_date',...
    'Percent_ft_date_tot'});
ft_country_norm = removevars(ft_country_norm,{'Percent_ft_country',...
    'Percent_ft_country_tot'});

ft_date_norm.Properties.VariableNames = {'Date' 'Mutants_number' 'Total_Tests'};
ft_country_norm.Properties.VariableNames = {'Country' 'Mutants_number' 'Total_Tests'};

[t1,~] = printMutation(db.NTScore ,db.NTMutation,db.Date,...
    db.Country,db.Header);

[t2,~] = printMutation(db.AAScore ,db.AAMutation,db.Date,...
    db.Country,db.Header);

disp("saving Results...");
%% delete (dir.base+dir.data+"Mutations_"+version2+"_"+n+"_"+m+".xlsx");
writetable(t1,dirc.Output+"\Mutations_"+version.Output+"_"+n+"_"+m+".xlsx",'Sheet','Nucleotide Seq','UseExcel',false);
writetable(t2,dirc.Output+"\Mutations_"+version.Output+"_"+n+"_"+m+".xlsx",'Sheet','Amino Acid Seq','UseExcel',false);

writetable(ft_NT_seq_loc,dirc.Output+"\Mutations_"+version.Output+"_"+n+"_"+m+".xlsx",'Sheet','Nucleotide Frequency','UseExcel',false);
writetable(ft_AA_seq_loc,dirc.Output+"\Mutations_"+version.Output+"_"+n+"_"+m+".xlsx",'Sheet','Amino Acid Frequency','UseExcel',false);

writetable(ft_NT_loc,dirc.Output+"\Mutations_"+version.Output+"_"+n+"_"+m+".xlsx",'Sheet','NT Location Frequency','UseExcel',false);
writetable(ft_AA_loc,dirc.Output+"\Mutations_"+version.Output+"_"+n+"_"+m+".xlsx",'Sheet','AA Location Frequency','UseExcel',false);

writetable(ft_date_norm,dirc.Output+"\Mutations_"+version.Output+"_"+n+"_"+m+".xlsx",'Sheet','Date Frequency','UseExcel',false);
writetable(ft_country_norm,dirc.Output+"\Mutations_"+version.Output+"_"+n+"_"+m+".xlsx",'Sheet','Country Frequency','UseExcel',false);

disp("done!");
