function db_out = StructureCut(db_in,indx_keep)

fields = fieldnames(db_in);

for i=1:numel(fields)
    column = db_in.(fields{i});
    if ~isstruct(column)
        db_out.(fields{i}) = column(indx_keep);
    else
        subFields = fieldnames(column);
        for j=1:numel(subFields)
            subColumn = column.(subFields{j});
            db_out.(fields{i}).(subFields{j}) = subColumn(indx_keep);
        end
    end
        
end