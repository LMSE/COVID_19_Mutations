function db_out = ConcatStruct(S)
    db_inner = fieldnames(S);
    fields = fieldnames(S(1).(db_inner{1}));
    f = fields';
    f{2,1} = [];
    db_out = struct(f{:});
    
    for field=1:length(fields)
        for concat=1:length(S)
            db_in = S(concat).(db_inner{1});
            db_out.(fields{field})= [db_out.(fields{field}); db_in.(fields{field})];
        end
    end
end