function [db, OffNumbers] = ThresholdScore(db, Threshold)

%
    indx = cellfun(@(data) data>= Threshold,db.AAScore);
    
    OffNumbers = length(indx);
    db.FrameOne = db.FrameOne(indx~=0);
    db.FrameTwo = db.FrameTwo(indx~=0);
    db.FrameThree = db.FrameThree(indx~=0);
    db.Header = db.Header(indx~=0);
    db.NTSeq = db.NTSeq(indx~=0);
    db.Country = db.Country(indx~=0);
    db.Date=db.Date(indx~=0);
    if isfield(db,'NTScore')
        db.NTScore = db.NTScore(indx~=0);
        db.NTAlignment = db.NTAlignment(indx~=0);
    end
    db.AAScore = db.AAScore(indx~=0);
    db.Aalignment = db.Aalignment(indx~=0);
end