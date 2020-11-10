%% this script set global variables
clear;
clear global version Delimiter dirc loc fasta flag result m n;
global version Delimiter dirc fasta flag result m n;
m=1;
%%
version.Input = 'V10'; %% the version for obtaining Inputs
version.Output = 'V30'; %% the version for saving results

Delimiter = "|";
%% Setting up main directories
currentFolder = strsplit(pwd,{'/','\'});
disp(currentFolder)
i = length(currentFolder);
dirc.base = sprintf('%s/',currentFolder{1:i-1});
dirc.Input = dirc.base + "Input";
dirc.Output = dirc.base + "Output";
dirc.Database = dirc.Input + "/Database";
%% Setting up databases
flag = 1; % Reading frames exists
if ~exist(dirc.Database, 'dir')
   mkdir(dirc.Database)
   flag = 0; % Reading frames does not exists
else
    check = dir(dirc.Database);
    if numel({check.name})<= 2
        flag = 0; % the database folder is empty
    end
end
if ~exist(dirc.Output, 'dir')
    mkdir(dirc.Output)
end
file = dir(dirc.Output+"/Result_db*");
exists = size(file);
if exists(1)>0
    flag = 2; %% Curated data is already available
    result =  dir(dirc.Output+"/Result_db*").name;
    array = strsplit(result,'_');
    m = strsplit(array{5},'.');
    m = str2double(m{1});
    n = str2double(array{4});
end
%% Setting up input fasta files
fasta.db = dirc.Input + "/gisaid_database.fasta";
fasta.fastaseq = dirc.Input +"/Seq.fasta";
fasta.pdb = dirc.Input +"/PDB.fasta";
%% clear variables
clear currentFolder file exists i;




