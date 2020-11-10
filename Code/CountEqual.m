function [countEqu,db_out,nonEqu_indx] = CountEqual(block,db_in)

% Count exactly equal sequences
countEquNT_indx = find(cellfun(@(data) isequal(data, block.NTSeq),db_in.NTSeq));
countEquAA_indx_1 = find(cellfun(@(data) isequal(data, block.AASeq),db_in.FrameOne));
countEquAA_indx_2 = find(cellfun(@(data) isequal(data, block.AASeq),db_in.FrameTwo));
countEquAA_indx_3 = find(cellfun(@(data) isequal(data, block.AASeq),db_in.FrameThree));

countEqu_indx = union(union(union(countEquNT_indx,countEquAA_indx_1),...
    countEquAA_indx_2),countEquAA_indx_3);

countEqu = length(countEqu_indx);

% Return non-equal sequences in the format of a structure
nonEqu_indx = setdiff(1:length(db_in.NTSeq),countEqu_indx);

db_out = StructureCut(db_in,nonEqu_indx);
    
end