function [db] = NtlocalAlignment(seq,db)
    % this function is wrriten to calculate the local alignment score for
    % all the sequences in the database against a given sequence. Then,
    % 100% matches are removed from the db and only those with mutations
    % are remained
    
    disp("Estimated Time for Nucleotide Seq Alignment is:");
    disp(string(0.82*length(db.NTSeq))+" Seconds");
    RealScore = localalign(seq,seq,'DoAlignment',false); % Calculating 100% Similairty Score
    RealScore = RealScore.Score;
    % Calculating Local Similarity
    tic
    resAlign = cellfun(@(data) localalign(seq,data),...
        db.NTSeq,'UniformOutput',false);

    db.NTScore = cellfun(@(data)  round(data.Score/RealScore*100,3) , resAlign,'UniformOutput',false);
    db.NTAlignment = cellfun(@(data)  data.Alignment,resAlign,'UniformOutput',false);
    toc
end