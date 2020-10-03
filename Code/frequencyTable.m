function T = frequencyTable(CellVector,varargin)
% @Parameter the vector for which you want to obtain the frequency table
% You can input pairs of data that are separated by a Delimiter
% Delimiter must be inputed as the second argument
if nargin >2
    error("Too much input Argument: input CellVector and Delimiter type");
end
elements = vertcat(CellVector{:});
[NameList,~,iNames] = unique(elements,'stable');  
Frequency = histcounts(iNames,numel(NameList)).';
if nargin >1 
    Delimiter = varargin{1};
    res = cellfun(@(data) strsplit(data,Delimiter),NameList,'UniformOutput',false);
    Var1 = cellfun(@(data) data{1},res,'UniformOutput',false);
    Var2 = cellfun(@(data) data{2},res,'UniformOutput',false);
    T = table(NameList,Var1,Var2,Frequency, Frequency/length(elements)*100);
    T = sortrows(T,3,'descend');
    T.Properties.VariableNames = {'GivenCell' 'Var1' 'Var2' 'Count' 'Percent'};
else
    
    T = table(NameList,Frequency, Frequency/length(elements)*100);
    T = sortrows(T,2,'descend');
    T.Properties.VariableNames = {'GivenCell' 'Count' 'Percent'};
end
% t = sortrows(tabulate(cell2mat(cellfun(@(data) data(:),CellVector...
%     ,'UniformOutput',false))),2,'descend');
% if ~iscell(t(2,:))
%     t = t(any(t(:,3),2),:);
% end
% t = array2table(t);
% t.Properties.VariableNames = {'Input' 'Count' 'Percent'};
% disp(t)
end