function [countEqu,db,nonEqu_indx] = CountEqual(block,db)
% Count exactly equal sequences
countEquNT_indx = find(cellfun(@(data) isequal(data, block.NTSeq),db.NTSeq));
countEquAA_indx_1 = find(cellfun(@(data) isequal(data, block.AASeq),db.FrameOne));
countEquAA_indx_2 = find(cellfun(@(data) isequal(data, block.AASeq),db.FrameTwo));
countEquAA_indx_3 = find(cellfun(@(data) isequal(data, block.AASeq),db.FrameThree));

countEqu_indx = union(union(union(countEquNT_indx,countEquAA_indx_1),...
    countEquAA_indx_2),countEquAA_indx_3);
countEqu = length(countEqu_indx);

% Return non-equal sequences in the format of a structure
nonEqu_indx = setdiff(1:length(db.NTSeq),countEqu_indx);
db.NTSeq = db.NTSeq(nonEqu_indx);
db.FrameOne = db.FrameOne(nonEqu_indx);
db.FrameTwo = db.FrameTwo(nonEqu_indx);
db.FrameThree = db.FrameThree(nonEqu_indx);
db.Header = db.Header(nonEqu_indx);
    
end