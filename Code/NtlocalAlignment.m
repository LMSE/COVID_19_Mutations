function [db] = NtlocalAlignment(seq,db)
    % this function is wrriten to calculate the local alignment score for
    % all the sequences in the database against a given sequence. Then,
    % 100% matches are removed from the db and only those with mutations
    % are remained
    
    disp("Estimated Time for Nucleotide Seq Alignment is:");
    disp(string(1.5*length(db.NTSeq))+" Seconds");
    RealScore = localalign(seq,seq,'DoAlignment',false, 'Alphabet','NT'); % Calculating 100% Similairty Score
    RealScore = RealScore.Score;
    % Calculating Local Similarity
    tic
    try
        resAlign = cellfun(@(data) localalign(seq,data,'Alphabet','NT'),...
            db.NTSeq,'UniformOutput',false);

    db.NTScore = cellfun(@(data)  round(data.Score/RealScore*100,3), resAlign,'UniformOutput',false);
    db.NTAlignment = cellfun(@(data)  data.Alignment,resAlign,'UniformOutput',false);
    toc
end