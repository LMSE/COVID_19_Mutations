function Block  = CreateSequence(DirectoryOrNCBI)
    % Reading a nucleotide sequence from a single fasta file 
    % or getting the sequence from NCBI and convert it to Protein
    % sequence @Param the location of the fastafile or its NCBI name
    if isfile(DirectoryOrNCBI)
        % read from file
        FastaData =  fastaread(DirectoryOrNCBI);
        Sequence=FastaData.Sequence;
    else
        % read from NCBI
        NCBIname = input("Cannot find the input fasta file. Enter the NCBI name: ");
        Sequence =  getgenbank(NCBIname,'SequenceOnly', true);
    end
    Protein = nt2aa(Sequence,'AlternativeStartCodons',false);
    Block.NTSeq = Sequence;
    Block.AASeq = Protein;
    Block.BNSeq = Block.NTSeq(1,22544:23146);
    Block.BASeq = nt2aa(Block.BNSeq,'AlternativeStartCodons',false);
end