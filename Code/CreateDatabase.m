function database = CreateDatabase(directory)
    % reading the fastafile of nucleotide Sequences to create the 
    % refernece database
    % @Param the directory of the fastafile
    tic
    FastaDb = fastaread(directory);
    n = length(FastaDb);
    SequenceDb = cell(n,1);
    HeaderDb = cell(n,1);
    disp("Reading the Given FastaFile")
    parfor i=1:n
        SequenceDb{i,1} = FastaDb(i).Sequence;
        HeaderDb{i,1} = FastaDb(i).Header;
    end
    disp("Curing the Data")
    % Removing sequences which include gapes 
    SequenceDb = cellfun(@(x) upper(x),SequenceDb,'UniformOutput',false);
%     SequenceDb = SequenceDb(~cellfun(@(x) ismember('N',x),SequenceDb));
    SequenceDb = SequenceDb(~cellfun(@(x) ismember('-',x),SequenceDb));
        SequenceDb = SequenceDb(~cellfun(@(x) ismember(' ',x),SequenceDb));
    % Coverting nucleotide Sequence to Amino Acid sequence
    disp("Generating Main Reading Frames")
    ProteinDbF1 = cellfun(@(x) nt2aa(x,'ACGTOnly',false,'AlternativeStartCodons',false),SequenceDb,'UniformOutput',false);
    disp("Frame One's Done");
    ProteinDbF2 = cellfun(@(x) nt2aa(x(1,2:end),'ACGTOnly',false,'AlternativeStartCodons',false),SequenceDb,'UniformOutput',false);
    disp("Frame Two's Done");
    ProteinDbF3 = cellfun(@(x) nt2aa(x(1,3:end),'ACGTOnly',false,'AlternativeStartCodons',false),SequenceDb,'UniformOutput',false);
    disp("Frame Three's Done");
    % Creating the database
    database.FrameOne =  ProteinDbF1;
    database.FrameTwo =  ProteinDbF2;
    database.FrameThree =  ProteinDbF3;
    database.NTSeq = SequenceDb;
    database.Header = HeaderDb;
    toc
end