function db_out = StructureCut(db_in,indx_keep)

fields = fieldnames(db_in);

for i=1:numel(fields)
    column = getfield(db_in,fields{i});
    db_in = setfield(db_in,fields{i},column(indx_keep));
end

db_out = db_in;