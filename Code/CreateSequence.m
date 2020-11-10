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
        NCBIname = input("Cannot find the input fasta file. Enter the NCBI name: ",'s');
        Sequence =  getgenbank(NCBIname,'SequenceOnly', true);
    end
    Protein = nt2aa(Sequence,'AlternativeStartCodons',false);
    Block.NTSeq = Sequence;
    Block.AASeq = Protein;
    input_a = input('Eneter 1 for RBD fragment, enter 2 for extended RBD fragment => ');
    if input_a ==1 
        Block.BNSeq = Block.NTSeq(1,22544:23146);
    elseif input_a == 2
        Block.BNSeq = Block.NTSeq(1,22544:23407);
    else 
        warning('Input non valide, assuming RBD fragment');
        Block.BNSeq = Block.NTSeq(1,22544:23146);
    end
    Block.BASeq = nt2aa(Block.BNSeq,'AlternativeStartCodons',false);
end