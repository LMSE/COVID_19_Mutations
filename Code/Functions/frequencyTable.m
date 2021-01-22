function T = frequencyTable(CellVector,varargin)
% @Parameter the vector for which you want to obtain the frequency table
% You can input pairs of data that are separated by a Delimiter
% Delimiter must be inputed as the second argument
% if you wanna find the residue of the standard sequence input it as the
% thir argument

elements = vertcat(CellVector{:});
[NameList,~,iNames] = unique(elements,'stable');  
Frequency = histcounts(iNames,numel(NameList)).';

switch nargin
    case 1
        T = table(NameList,Frequency, Frequency/length(elements)*100);
        T = sortrows(T,2,'descend');
        T.Properties.VariableNames = {'InputCell' 'Count' 'Percent'};
        
    case 2 % one delimter
        Delimiter = varargin{1};
        occurance = count( NameList{1}, Delimiter);    
        res = cellfun(@(data) strsplit(data,Delimiter),NameList,'UniformOutput',false);
        NameList = cellfun(@(data) erase(data,Delimiter),NameList,'UniformOutput',false);
        switch occurance 
            case 1
                Var1 = cellfun(@(data) data{1},res,'UniformOutput',false);
                Var2 = cellfun(@(data) data{2},res,'UniformOutput',false);
                T = table(NameList,Var1,Var2,Frequency, Frequency/length(elements)*100);
                T = sortrows(T,4,'descend');
                T.Properties.VariableNames = {'InputCell' 'Var1' 'Var2' 'Count' 'Percent'};
            case 2
                Var1 = cellfun(@(data) data{1},res,'UniformOutput',false);
                Var2 = cellfun(@(data) data{2},res,'UniformOutput',false);
                Var3 = cellfun(@(data) data{3},res,'UniformOutput',false);
                T = table(NameList,Var1,Var2,Var3,Frequency, Frequency/length(elements)*100);
                T = sortrows(T,5,'descend');
                T.Properties.VariableNames = {'InputCell' 'Var1' 'Var2' 'Var3' 'Count' 'Percent'};
            case 3
                Var1 = cellfun(@(data) data{1},res,'UniformOutput',false);
                Var2 = cellfun(@(data) data{2},res,'UniformOutput',false);
                Var3 = cellfun(@(data) data{3},res,'UniformOutput',false);
                Var4 = cellfun(@(data) data{4},res,'UniformOutput',false);
                T = table(NameList,Var1,Var2,Var3,Var4,Frequency, Frequency/length(elements)*100);
                T = sortrows(T,6,'descend');
                T.Properties.VariableNames = {'InputCell' 'Var1' 'Var2' 'Var3' 'Var4' 'Count' 'Percent'};
            otherwise
                error ("too many input variables in the first column")   
        end
    otherwise % one delimeter and one standard vector
        error("too many input arguments");
end   
end