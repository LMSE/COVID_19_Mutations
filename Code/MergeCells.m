function cell_3 = MergeCells(cell_1,Delimiter,varargin)

cell_3 = cell(size(cell_1));

switch nargin
    case 2
        cell_3 = cell_1;
    case 3
        disp("2 Cells given");
        cell_2 = varargin{1};
        parfor i = 1:length(cell_1)
            for j=1:length(cell_1{i})
                cell_3{i}(j,1) = strcat(num2str(cell_1{i}(j)),Delimiter,...
                    num2str(cell_2{i}(j)));
            end
        end
    case 4
        disp("3 Cells given");
        cell_2 = varargin{1};
        cell_4 = varargin{2};
         parfor i = 1:length(cell_1)
            for j=1:length(cell_1{i})
                cell_3{i}(j,1) = strcat(num2str(cell_1{i}(j)),Delimiter,...
                    num2str(cell_2{i}(j)), Delimiter, num2str(cell_4{i}(j)));
            end
         end
    case 5
        disp("4 Cells given");
        cell_2 = varargin{1};
        cell_4 = varargin{2};
        cell_5 = varargin{3};
         parfor i = 1:length(cell_1)
            for j=1:length(cell_1{i})
                cell_3{i}(j,1) = strcat(num2str(cell_1{i}(j)),Delimiter,...
                    num2str(cell_2{i}(j)), Delimiter, num2str(cell_4{i}(j))...
                    ,Delimiter, num2str(cell_5{i}(j)));
            end
         end
    otherwise
        disp("Unexpected Number of Cells");
        disp("Max 4 input");
end      
end