function MergeCell = MergeCells(MainCell,Delimiter,varargin)
% this function merge cells into one cell which is seperated by delimiter

MergeCell = cell(size(MainCell));
if iscell(MainCell{1})
    MainCell = cellfun(@(data) data{1}, MainCell,'UniformOutput', false);
end

switch nargin
    case 2 %% only one cell is given
        MergeCell = MainCell;
    case 3 %% Two cells are given
        subCell_1 = varargin{1};
        for i = 1:length(MainCell)
            for j=1:size(MainCell{i},1)
                MergeCell{i}(j,1) = strcat(num2str(MainCell{i}(j,:)),Delimiter,...
                    num2str(subCell_1{i}(j)));
            end
        end
    case 4 % 3 cells given
        subCell_1 = varargin{1};
        subCell_2 = varargin{2};
         for i = 1:length(MainCell)
            for j=1:size(MainCell{i},1)
                MergeCell{i}(j,1) = strcat(num2str(MainCell{i}(j,:)),Delimiter,...
                    num2str(subCell_1{i}(j)), Delimiter, num2str(subCell_2{i}(j)));
            end
         end
    case 5
        disp("4 Cells given");
        subCell_1 = varargin{1};
        subCell_2 = varargin{2};
        subCell_3 = varargin{3};
         for i = 1:length(MainCell)
            for j=1:size(MainCell{i},1)
                MergeCell{i}(j,1) = strcat(num2str(MainCell{i}(j,:)),Delimiter,...
                    num2str(subCell_1{i}(j)), Delimiter, num2str(subCell_2{i}(j))...
                    ,Delimiter, num2str(subCell_3{i}(j)));
            end
         end
    otherwise
        disp("Unexpected Number of Cells");
        disp("Max 4 input");
end      
end