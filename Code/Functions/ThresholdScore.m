function [db_1,db_2,OffNumbers] = ThresholdScore(db_new, Threshold)

% Filterin our those results which are completly off, 
% meaning that they show lots of mutation on their structure.

    indx = cellfun(@(data) data>= Threshold,db_new.NTScore);
    
    OffNumbers = length(indx);
    %% main numbers
    db_1 = StructureCut(db_new,indx~=0);
    
    %% highly mutated sequences
    db_2 = StructureCut(db_new,indx==0);
end