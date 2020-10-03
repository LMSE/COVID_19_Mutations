function [db] = AalocalAlignment(seq,db)
    % this function is wrriten to calculate the local alignment score for
    % all the Amino Acid sequences in the database against a given sequence. 
    % Then, 100% matches are removed from the db and only those with mutations
    % are remained
    
    
    RealScore = localalign(seq,seq, 'ScoringMatrix',...
        'pam250','DoAlignment',false); % Calculating 100% Similairty Score
    RealScore = RealScore.Score;
    % Calculating Local Similarity
    resAlign = cell(length(db.NTSeq),1);
    tic
    for i=1:length(db.NTSeq)
        resAlign_1 = localalign(seq,db.FrameOne{i},'ScoringMatrix','pam250');
        resAlign_2 = localalign(seq,db.FrameTwo{i},'ScoringMatrix','pam250');
        resAlign_3 = localalign(seq,db.FrameThree{i},'ScoringMatrix','pam250');
        [Score, indx] = max([resAlign_1.Score;resAlign_2.Score;resAlign_3.Score]);
        resAlign{i}.Score = Score;
        resAlign{i}.Alignment = [resAlign_1.Alignment;resAlign_2.Alignment; ...
            resAlign_3.Alignment];
        resAlign{i}.Alignment = resAlign{i}.Alignment(indx);
        if mod(i,100) == 0
            disp(i)
            toc
            tic
        end
    end
%     db.NTSeq = db.NTSeq(~EquIndx);
%     db.AASeq = db.AASeq(~EquIndx);
%     resAlign = resAlign(~EquIndx);
    db.AAScore = cellfun(@(data)  round(data.Score/RealScore*100,3) , resAlign,'UniformOutput',false);
    db.Aalignment = cellfun(@(data)  data.Alignment,resAlign,'UniformOutput',false);
end