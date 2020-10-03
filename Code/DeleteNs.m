function [db,nonEqu_indx] = DeleteNs(db)
if isfield(db,'Aalignment')
    indx = find(cellfun(@(data) ~ismember('X',data{1}(3,:)),db.Aalignment));
    db.FrameOne = db.FrameOne(indx);
    db.FrameTwo = db.FrameTwo(indx);
    db.FrameThree = db.FrameThree(indx);
    db.Header = db.Header(indx);
    db.NTSeq = db.NTSeq(indx);
    db.Country = db.Country(indx);
    db.Date=db.Date(indx);

    db.AAScore = db.AAScore(indx);
    db.Aalignment = db.Aalignment(indx);
    if isfield(db,'NTAlignment')
        db.NTScore = db.NTScore(indx);
        db.NTAlignment = db.NTAlignment(indx);
    end
elseif isfield(db,'NTAlignment')
    indx = find(cellfun(@(data) ismember('N',data{1}(3,:)),db.NTAlignment));
    db.FrameOne = db.FrameOne(indx);
    db.FrameTwo = db.FrameTwo(indx);
    db.FrameThree = db.FrameThree(indx);
    db.Header = db.Header(indx);
    db.NTSeq = db.NTSeq(indx);
    db.Country = db.Country(indx);
    db.Date=db.Date(indx);
    if isfield(db,'Aalignment')
        db.AAScore = db.AAScore(indx);
        db.Aalignment = db.Aalignment(indx);
    end
else
    indx = 1:length(db.NTSeq);
    error("Generate Alignment results first");
end
nonEqu_indx = setdiff(1:length(db.NTSeq),indx)';
end
