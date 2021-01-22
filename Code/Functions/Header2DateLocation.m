function db = Header2DateLocation(db)

n = length(db.Header);
splitDate = cellfun(@(data) strsplit(data,'|'), db.Header,'UniformOutput',false);
splitHeader = cellfun(@(data) strsplit(data,'/'), db.Header,'UniformOutput',false);
DateDb = cell(n,1);
LocationDb = cell(n,1);

parfor i=1:n
    try
        DateDb{i,1} = datetime(splitDate{i}(3),'InputFormat','yyyy-MM-dd');
    catch
        try
            DateDb{i,1} = datetime(splitDate{i}(3),'InputFormat','yyyy-MM');
        catch
            DateDb{i,1} = datetime(splitDate{i}(3),'InputFormat','yyyy');
        end
    end
        LocationDb{i,1} = splitHeader{i}(2);
end
db.Date = DateDb;
db.Country = LocationDb;
end