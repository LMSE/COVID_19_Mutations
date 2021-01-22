function [db_out,nonEqu_indx] = DeleteNs(db_in)

if isfield(db_in,'NTAlignment')
 
    indx = find(cellfun(@(data) numel(unique(data{1}(3,:)))<=4,...
        db_in.NTAlignment));
    db_out = StructureCut(db_in,indx);
	
	indx = find(cellfun(@(data) numel(unique(data{1}(1,:)))<=4,...
        db_out.NTAlignment));
    db_out = StructureCut(db_out,indx);
	
elseif isfield(db_in,'Aalignment')
    indx = find(~cell2mat(db_in.Flag));
    db_out = StructureCut(db_in,indx);
end


nonEqu_indx = setdiff(1:length(db_in.NTSeq),indx)';
end
