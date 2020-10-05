function database = CreateDatabase()
    % reading the fastafile of nucleotide Sequences to create the 
    % refernece database
    % @Param the directory of the fastafile
    
    global loc fasta flag m n result dirc;
    
    if flag == 0 %% reading frames does not exists. generate them
        disp(" Loading %s database",fasta.db);
        
        FastaDb = fastaread(fasta.db);
        m = length(FastaDb);
        n = 1;
        
        %% check for subset consideration
        comment = sprintf("Gisaid Database size : %d by %d",n,m);
        fprintf(comment);
        part = input("\nConsider a subset of the database? [y,n]",'s');
        
        if part == 'y'
            n = input("Enter starting index :");
            m = input("Enter final index :");
        end
        %% Generating reading frames
        SequenceDb = cell(m,1);
        HeaderDb = cell(m,1);
        parfor i=1:m
            SequenceDb{i,1} = FastaDb(i).Sequence;
            HeaderDb{i,1} = FastaDb(i).Header;
        end
        disp("Curating the Data ...")
        % Removing sequences which include gapes 
        SequenceDb = cellfun(@(x) upper(x),SequenceDb,'UniformOutput',false);
        % SequenceDb = SequenceDb(~cellfun(@(x) ismember('N',x),SequenceDb));
        SequenceDb = SequenceDb(~cellfun(@(x) ismember('-',x),SequenceDb));
        SequenceDb = SequenceDb(~cellfun(@(x) ismember(' ',x),SequenceDb));
        % Coverting nucleotide Sequence to Amino Acid sequence

        disp("Generating Main Reading Frames for the input database ...")
        ProteinDbF1 = cellfun(@(x) nt2aa(x,'ACGTOnly',false,...
            'AlternativeStartCodons',false),SequenceDb,'UniformOutput',false);
        disp("Frame One is generated successfully");
        ProteinDbF2 = cellfun(@(x) nt2aa(x(1,2:end),'ACGTOnly',false,'AlternativeStartCodons',false),SequenceDb,'UniformOutput',false);
        disp("Frame Two is generated successfully");
        ProteinDbF3 = cellfun(@(x) nt2aa(x(1,3:end),'ACGTOnly',false,'AlternativeStartCodons',false),SequenceDb,'UniformOutput',false);
        disp("Frame Three is generated successfully");
        % Creating the database
        database.FrameOne =  ProteinDbF1;
        database.FrameTwo =  ProteinDbF2;
        database.FrameThree =  ProteinDbF3;
        database.NTSeq = SequenceDb;
        database.Header = HeaderDb;
        
    elseif flag == 1 %% reading frames exists, loading them
        disp("Loading Reading frames ...")
        load(loc.a);
        load(loc.b);
        load(loc.c);
        load(loc.d{1});
        load(loc.d{2});
        load(loc.d{3});
        load(loc.e);
        
        database.FrameOne = db_a; database.FrameTwo = db_b; database.FrameThree = db_c;
        database.NTSeq = [db_d1;db_d2;db_d3];
        database.Header = db_e;
        n = 1;
        m = length(database.NTSeq);
        disp("Loaded!")
    elseif flag == 2
        load(dirc.Output+"/"+result);
        database = db_copy4;
        clear db_copy4;
    end 
end