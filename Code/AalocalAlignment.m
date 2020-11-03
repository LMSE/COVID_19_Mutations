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

        flag1 = aminolookup_defined(db.FrameOne{i});
        flag2 = aminolookup_defined(db.FrameTwo{i});
        flag3 = aminolookup_defined(db.FrameThree{i});
        flag = [flag1;flag2;flag3];
            
        resAlign_1 = localalign(seq,db.FrameOne{i},'ScoringMatrix','pam250');
        resAlign_2 = localalign(seq,db.FrameTwo{i},'ScoringMatrix','pam250');
        resAlign_3 = localalign(seq,db.FrameThree{i},'ScoringMatrix','pam250');
        
        [Score, indx] = max([resAlign_1.Score;resAlign_2.Score;resAlign_3.Score]);
        
        indx_unavailable_aa = find(flag);  % find the position of nonzero elements
        
        % compare the results of score to the index of the unavailble amino acid
        flag_final = ismember(indx,indx_unavailable_aa);
        
        resAlign{i}.Alignment = [resAlign_1.Alignment;resAlign_2.Alignment; ...
            resAlign_3.Alignment];
        resAlign{i}.Score = Score;
        resAlign{i}.Alignment = resAlign{i}.Alignment(indx);
        resAlign{i}.Flag = flag_final;
        
        if mod(i,100) == 0
            disp(i)
            toc
            tic
        end
    end

    db.AAScore = cellfun(@(data)  round(data.Score/RealScore*100,3) , resAlign,'UniformOutput',false);
    db.Aalignment = cellfun(@(data)  data.Alignment,resAlign,'UniformOutput',false);
    db.Flag = cellfun(@(data)  data.Flag,resAlign,'UniformOutput',false);
end