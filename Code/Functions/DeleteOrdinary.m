function [db_out,countEqu] = DeleteOrdinary(db_in,AlignVector,countEqu)

    check = {':', ' '};
    %% Counting indexes without mutations
    indxEqu = cellfun(@isempty, cellfun(@(data) regexp(data{1}(2,:),strjoin(check,'|'))'  ,...
        AlignVector,'UniformOutput',false));
    countEqu = countEqu + length(find(indxEqu));
    %% Counting alignments that have mutations
    indx = cellfun(@(data) ~isempty(data),...
        cellfun(@(data) regexp(data{1}(2,:),strjoin(check,'|'))'  ,...
        AlignVector,'UniformOutput',false));
    db_out = StructureCut(db_in,indx);
end