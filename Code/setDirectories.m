%% this script set global variables
global version Delimiter dirc loc fasta flag;
%%
version.Input = 'V10'; %% the version for obtaining Inputs
version.Output = 'V20'; %% the version for saving results

Delimiter = "|";
%% Setting up main directories
currentFolder = strsplit(pwd,'\');
n = length(currentFolder);
dirc.base = sprintf('%s/',currentFolder{1:n-1});
dirc.Input = dirc.base + "Input";
dirc.Output = dirc.base + "Output";
dirc.Database = dirc.Input + "/Database";
%% Setting up databases
flag = 1; % the database exists
if ~exist(dirc.Database, 'dir')
   mkdir(dirc.Database)
   flag = 0; % the database does not exists
else
    if length({dir(dirc.Database).name})<= 2
        flage = 0; % the database folder is empty
    end
end
%% Setting up input fasta files
fasta.db = {'/gisaid_hcov-19_2020-05-01.fasta';...
    '/gisaid_hcov-19_2020-07-01.fasta';...
    '/gisaid_hcov-19_2020-09-23.fasta'};
fasta.db = cellfun(@(data) dirc.Input+data,fasta.db,'uni',false);
fasta.fastaseq = dirc.Input +"/Seq.fasta";
fasta.pdb = dirc.Input +"/PDB.fasta";
%% Break database to smaller unites
loc.a = dirc.Database+'Database_'+version.Input+'_FrameOne.mat'; %% database location for reading frame three
loc.b = dirc.Database+'Database_'+version.Input+'_FrameTwo.mat'; %% database location for reading frame two
loc.c = dirc.Database+'Database_'+version.Input+'_FrameThree.mat'; %% database location for reading frame one
loc.d = {dirc.Database+'Database_'+version.Input+'_NTSeq1.mat'; %% database location for NT seq
 dirc.Database+'Database_'+version.Input+'_NTSeq2.mat'; %% database location for NT seq
 dirc.Database+'Database_'+version.Input+'_NTSeq3.mat'}; %% database location for NT seq
loc.e = dirc.Database+'Database_'+version.Input+'_Header.mat'; %% database location of Header
%% clear variables
clear n currentFolder;




