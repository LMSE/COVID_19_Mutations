function [db_1,db_2,OffNumbers] = ThresholdScore(db_new, Threshold)

% Filterin our those results which are completly off, 
% meaning that they show lots of mutation on their structure.

    indx = cellfun(@(data) data>= Threshold,db_new.NTScore);
    
    OffNumbers = length(indx);
    %% main numbers
    db_1.FrameOne = db_new.FrameOne(indx~=0);
    db_1.FrameTwo = db_new.FrameTwo(indx~=0);
    db_1.FrameThree = db_new.FrameThree(indx~=0);
    db_1.Header = db_new.Header(indx~=0);
    db_1.NTSeq = db_new.NTSeq(indx~=0);
    db_1.Country = db_new.Country(indx~=0);
    db_1.Date=db_new.Date(indx~=0);
    if isfield(db_new,'NTScore')
        db_1.NTScore = db_new.NTScore(indx~=0);
        db_1.NTAlignment = db_new.NTAlignment(indx~=0);
    end
    db_1.AAScore = db_new.AAScore(indx~=0);
    db_1.Aalignment = db_new.Aalignment(indx~=0);
    db_1.NTMutation.Loc = db_new.NTMutation.Loc(indx~=0);
    db_1.NTMutation.One = db_new.NTMutation.One(indx~=0);
    db_1.NTMutation.Two = db_new.NTMutation.Two(indx~=0);
    db_1.AAMutation.Loc = db_new.AAMutation.Loc(indx~=0);
    db_1.AAMutation.One = db_new.AAMutation.One(indx~=0);
    db_1.AAMutation.Two = db_new.AAMutation.Two(indx~=0);
    %% highly mutated sequences
    db_2.FrameOne = db_new.FrameOne(indx==0);
    db_2.FrameTwo = db_new.FrameTwo(indx==0);
    db_2.FrameThree = db_new.FrameThree(indx==0);
    db_2.Header = db_new.Header(indx==0);
    db_2.NTSeq = db_new.NTSeq(indx==0);
    db_2.Country = db_new.Country(indx==0);
    db_2.Date=db_new.Date(indx==0);
    if isfield(db_new,'NTScore')
        db_2.NTScore = db_new.NTScore(indx==0);
        db_2.NTAlignment = db_new.NTAlignment(indx==0);
    end
    db_2.AAScore = db_new.AAScore(indx==0);
    db_2.Aalignment = db_new.Aalignment(indx==0);
    db_2.NTMutation.Loc = db_new.NTMutation.Loc(indx==0);
    db_2.NTMutation.One = db_new.NTMutation.One(indx==0);
    db_2.NTMutation.Two = db_new.NTMutation.Two(indx==0);
    db_2.AAMutation.Loc = db_new.AAMutation.Loc(indx==0);
    db_2.AAMutation.One = db_new.AAMutation.One(indx==0);
    db_2.AAMutation.Two = db_new.AAMutation.Two(indx==0);
end