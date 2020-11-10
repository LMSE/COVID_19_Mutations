% flag == 0 only the NT sequences are available!
% flag == 1 the reading frames are generated!
% flag ==2 Alignment results are generated!
clc;
setDirectories
global version Delimiter dirc fasta flag m n;
%% read Input fasta files: Given Sequence and Given database
block =  CreateSequence(fasta.fastaseq);
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
db_standard = CreateDatabase();
%% Control of variables
if flag == 1 
        %% check for subset consideration
        comment = sprintf("Gisaid Database size : %d by %d \n",n,m);
        fprintf(comment);
         part = input("\nConsider a subset of the database for alignment? [y,n]",'s');
        % default
        % part = 'n';
        if part == 'y'
            n = input("Enter starting index :");
            m = input("Enter final index :");
            db_standard = StructureCut(db_standard, n:m);
        end
        [countEqu,db_standard, indx_Equ] = CountEqual(block,db_standard);
        disp("the NCBI Sequence is repeated "+countEqu+" times in the Gisaid database");
        
    disp("Extracting Date and Country of the reported Sequences");
    db_standard = Header2DateLocation(db_standard);
    
    % Amino Acid Local Alignment
    disp("Aligning Amino Acid Sequences")
    db_standard = AalocalAlignment(block.BASeq,db_standard);
    
    % Delete sequences that don't have full coverage in the binding domain   
    [db_standard, indx_fullCoverage] = DeleteNs(db_standard);
    disp("number of deleted sequences due to the existance of a un categorized amino acid " + numel(indx_fullCoverage));
    
    % Calculating the total number of tests performed at each Date and
    % Country & Date
    ft_date_tot = frequencyTable(db_standard.Date);
    ft_country_tot = frequencyTable(db_standard.Country);
    
    % Nucleotide Local Alignment
    disp("Aligning Nucleotide sequences ... ")
    db_standard = NtlocalAlignment(block.BNSeq,db_standard);
    
    [db_standard, indx_fullCoverage] = DeleteNs(db_standard);
    disp("number of deleted sequences due to the existance of a un categorized nucleotide" + numel(indx_fullCoverage));
    
    % Spotting the mutations
    disp("Spoting Mutations in the amino acid sequence");
    db_standard.AAMutation = LocateMutants(block.BASeq,db_standard.Aalignment);
    
    disp("Spoting Mutations in the Nucleotide sequence");
    db_standard.NTMutation = LocateMutants(block.BNSeq,db_standard.NTAlignment);
    
    % Deleting non-mutated records
    [db_standard,countEqu] = DeleteOrdinary(db_standard,db_standard.NTAlignment,countEqu);
    disp("total number of non-mutated sequences in the database: "+countEqu);
    
    items = numel(db_standard.NTSeq);
    sections = ceil(linspace(0,items,5));
    for parts=2:5
       res =  dirc.Output+"/Result_db_"+parts+"_"+version.Output+"_"+n+"_"+m+".mat";
       db_parts = StructureCut(db_standard,sections(parts-1)+1:sections(parts));
       disp("Saving the result in "+ res);
       save(res,"db_parts");
    end
    flag = 2;
elseif flag == 2 %% load the original data to normalize frequency
    flag = 1;
    db_norm = CreateDatabase();
    
    [countEqu,db_norm,~] = CountEqual(block,db_norm);
    
    disp("Extracting Date and Country of the reported Sequences");
    db_norm = Header2DateLocation(db_norm);
    db_norm = AalocalAlignment(block.BASeq,db_norm);
    % Delete sequences that don't have full coverage in the binding domain
    [db_norm, indx_fullCoverage] = DeleteNs(db_norm);
    
    % Calculating the total number of tests performed at each Date and
    % Country
    ft_date_tot = frequencyTable(db_norm.Date);
    ft_country_tot = frequencyTable(db_norm.Country);
%     clear db_norm
end
%%
% Remove sequences which are extremely dissimilar to the original sequence
[db_1, db_2, OffNum] = ThresholdScore(db_standard,97);
disp("number of acceptable mutated sequences: "+ OffNum);

db_list = {db_1;db_2};
for i=1:length(db_list)
    db_test = db_list{i};
    disp("Analyzing Identified Mutations ...");
    ft_NT_loc = frequencyTable(db_test.NTMutation.Loc);
    ft_AA_loc = frequencyTable(db_test.AAMutation.Loc);

    ft_NT_seq_loc = frequencyTable(MergeCells(db_test.NTMutation.Two,Delimiter,...
    db_test.NTMutation.Loc),Delimiter);
    ft_AA_seq_loc = frequencyTable(MergeCells(db_test.AAMutation.Two,Delimiter,...
    db_test.AAMutation.Loc),Delimiter);

    ft_date = frequencyTable(db_test.Date);
    ft_country = frequencyTable(db_test.Country);

    ft_date_norm = innerjoin(ft_date,ft_date_tot,'LeftKeys',1,'RightKeys',1);
    ft_country_norm = innerjoin(ft_country,ft_country_tot,'LeftKeys',1,'RightKeys',1);

    ft_date_norm = removevars(ft_date_norm,{'Percent_ft_date',...
    'Percent_ft_date_tot'});
    ft_country_norm = removevars(ft_country_norm,{'Percent_ft_country',...
    'Percent_ft_country_tot'});

    ft_date_norm.Properties.VariableNames = {'Date' 'Mutants_number' 'Total_Tests'};
    ft_country_norm.Properties.VariableNames = {'Country' 'Mutants_number' 'Total_Tests'};

    [t1,~] = printMutation(db_test.NTScore ,db_test.NTMutation,db_test.Date,...
        db_test.Country,db_test.Header);

    [t2,~] = printMutation(db_test.AAScore ,db_test.AAMutation,db_test.Date,...
        db_test.Country,db_test.Header);
    disp("saving Results...");
    version.Output = 4;
    writetable(t1,dirc.Output+"/Mutations_"+version.Output+i+"_"+n+"_"+m+".xlsx",'Sheet','Nucleotide Seq','UseExcel',false);
    writetable(t2,dirc.Output+"/Mutations_"+version.Output+i+"_"+n+"_"+m+".xlsx",'Sheet','Amino Acid Seq','UseExcel',false);

    writetable(ft_NT_seq_loc,dirc.Output+"/Mutations_"+version.Output+i+"_"+n+"_"+m+".xlsx",'Sheet','Nucleotide Frequency','UseExcel',false);
    writetable(ft_AA_seq_loc,dirc.Output+"/Mutations_"+version.Output+i+"_"+n+"_"+m+".xlsx",'Sheet','Amino Acid Frequency','UseExcel',false);

    writetable(ft_NT_loc,dirc.Output+"/Mutations_"+version.Output+i+"_"+n+"_"+m+".xlsx",'Sheet','NT Location Frequency','UseExcel',false);
    writetable(ft_AA_loc,dirc.Output+"/Mutations_"+version.Output+i+"_"+n+"_"+m+".xlsx",'Sheet','AA Location Frequency','UseExcel',false);

    writetable(ft_date_norm,dirc.Output+"/Mutations_"+version.Output+i+"_"+n+"_"+m+".xlsx",'Sheet','Date Frequency','UseExcel',false);
    writetable(ft_country_norm,dirc.Output+"/Mutations_"+version.Output+i+"_"+n+"_"+m+".xlsx",'Sheet','Country Frequency','UseExcel',false);

end