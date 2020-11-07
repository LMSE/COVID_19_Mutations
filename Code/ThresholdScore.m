function [db_1,db_2,OffNumbers] = ThresholdScore(db, Threshold)

% Filterin our those results which are completly off, 
% meaning that they show lots of mutation on their structure.

    indx = cellfun(@(data) data>= Threshold,db.NTScore);
    
    OffNumbers = length(indx);
    %% main numbers
    db_1.FrameOne = db.FrameOne(indx~=0);
    db_1.FrameTwo = db.FrameTwo(indx~=0);
    db_1.FrameThree = db.FrameThree(indx~=0);
    db_1.Header = db.Header(indx~=0);
    db_1.NTSeq = db.NTSeq(indx~=0);
    db_1.Country = db.Country(indx~=0);
    db_1.Date=db.Date(indx~=0);
    if isfield(db,'NTScore')
        db_1.NTScore = db.NTScore(indx~=0);
        db_1.NTAlignment = db.NTAlignment(indx~=0);
    end
    db_1.AAScore = db.AAScore(indx~=0);
    db_1.Aalignment = db.Aalignment(indx~=0);
    db_1.NTMutation.Loc = db.NTMutation.Loc(indx~=0);
    db_1.NTMutation.One = db.NTMutation.One(indx~=0);
    db_1.NTMutation.Two = db.NTMutation.Two(indx~=0);
    db_1.AAMutation.Loc = db.AAMutation.Loc(indx~=0);
    db_1.AAMutation.One = db.AAMutation.One(indx~=0);
    db_1.AAMutation.Two = db.AAMutation.Two(indx~=0);
    %% highly mutated sequences
    db_2.FrameOne = db.FrameOne(indx==0);
    db_2.FrameTwo = db.FrameTwo(indx==0);
    db_2.FrameThree = db.FrameThree(indx==0);
    db_2.Header = db.Header(indx==0);
    db_2.NTSeq = db.NTSeq(indx==0);
    db_2.Country = db.Country(indx==0);
    db_2.Date=db.Date(indx==0);
    if isfield(db,'NTScore')
        db_2.NTScore = db.NTScore(indx==0);
        db_2.NTAlignment = db.NTAlignment(indx==0);
    end
    db_2.AAScore = db.AAScore(indx==0);
    db_2.Aalignment = db.Aalignment(indx==0);
    db_2.NTMutation.Loc = db.NTMutation.Loc(indx==0);
    db_2.NTMutation.One = db.NTMutation.One(indx==0);
    db_2.NTMutation.Two = db.NTMutation.Two(indx==0);
    db_2.AAMutation.Loc = db.AAMutation.Loc(indx==0);
    db_2.AAMutation.One = db.AAMutation.One(indx==0);
    db_2.AAMutation.Two = db.AAMutation.Two(indx==0);
end