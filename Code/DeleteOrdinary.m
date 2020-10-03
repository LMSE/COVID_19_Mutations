function [db,countEqu] = DeleteOrdinary(db,AlignVector,countEqu)

    check = {':',' '};
    %% Counting indexes without mutations
    indxEqu = cellfun(@isempty, cellfun(@(data) regexp(data{1}(2,:),strjoin(check,'|'))'  ,...
        AlignVector,'UniformOutput',false));
    countEqu = countEqu + length(indxEqu);
    %% Counting alignments that have mutations
    indx = cellfun(@(data) ~isempty(data),...
        cellfun(@(data) regexp(data{1}(2,:),strjoin(check,'|'))'  ,...
        AlignVector,'UniformOutput',false));
%     countEqu = countEqu + length(find(cellfun(@(data) data==100, db.NTScore)));
%     indx = find(cellfun(@(data) data <100, db.NTScore));
    db.FrameOne = db.FrameOne(indx);
    db.FrameTwo = db.FrameTwo(indx);
    db.FrameThree = db.FrameThree(indx);
    db.Header = db.Header(indx);
    db.NTSeq = db.NTSeq(indx);
    db.Country = db.Country(indx);
    db.Date=db.Date(indx);
    if isfield(db,'NTScore')
        db.NTScore = db.NTScore(indx);
        db.NTAlignment = db.NTAlignment(indx);
    end
    if isfield(db,'AAScore')
        db.AAScore = db.AAScore(indx);
        db.Aalignment = db.Aalignment(indx);
    end
end