function result = IIF(statement, t, f)

if islogical(statement)
    if statement
        result = t;
    else
        result = f;
    end
else
    result = statement.*t + (~statement).*f;
end