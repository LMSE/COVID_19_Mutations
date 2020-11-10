function database = CreateDatabase()
    % reading the fastafile of nucleotide Sequences to create the 
    % refernece database
    % @Param the directory of the fastafile
    
    global loc fasta flag m n result dirc;
    
    if flag == 0 %% reading frames does not exists. generate them
        comment = sprintf (" Loading %s database\n",fasta.db);
        fprintf(comment);
        
        FastaDb = fastaread(fasta.db);
        %% Generating reading frames
        m = length(FastaDb);
        disp("the original database size is "+m);
        n = 1;
        SequenceDb = cell(m,1);
        HeaderDb = cell(m,1);
        parfor i=1:m
            SequenceDb{i,1} = FastaDb(i).Sequence;
            HeaderDb{i,1} = FastaDb(i).Header;
        end
        disp("Curating the Data and removing duplicates ...")
        % Removing sequences which include gapes 
        SequenceDb = cellfun(@(x) upper(x),SequenceDb,'UniformOutput',false);
        % SequenceDb = SequenceDb(~cellfun(@(x) ismember('N',x),SequenceDb));
        
        indx1 = cellfun(@(x) ismember('-',x),SequenceDb);
        SequenceDb = SequenceDb(~indx1);
        HeaderDb = HeaderDb(~indx1);
        indx2 = cellfun(@(x) ismember(' ',x),SequenceDb);
        HeaderDb = HeaderDb(~indx2);
        SequenceDb = SequenceDb(~indx2);
        
        [HeaderDb,indx3,~] = unique(HeaderDb);
        SequenceDb = SequenceDb(indx3);
        
        indx4 = find(~contains(HeaderDb,{'/cat' '/tiger' '/dog' '/mink' '/lion'...
            '/Environment' '/Canine' '/bat'}));
        SequenceDb = SequenceDb(indx4);
        HeaderDb = HeaderDb(indx4);
        
        clear indx1 indx2 indx3 indx4;
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
        % adjusting the value of n and m after data curation and gap removal
        n = 1;
        m = length(database.NTSeq);
        disp("the size of the database after removing low coverage sequences is "+m);
        
        clear ProteinDbF1 ProteinDbF2 ProteinDbF3 SequenceDb HeaderDb;
        %% Saving reading frames
        Blank = numel(database.FrameOne);
        Q1 = ceil(Blank/4);
        Q2 = Q1*2;
        Q3 = Q1*3;
        
        db_a1 = database.FrameOne(1:Q2,1);
        db_a2 = database.FrameOne(Q2+1:end,1);
        
        db_b1 = database.FrameTwo(1:Q2,1);
        db_b2 = database.FrameTwo(Q2+1:end,1);
        
        db_c1 = database.FrameThree(1:Q2,1);
        db_c2 = database.FrameThree(Q2+1:end,1);
        
        db_d1 = database.NTSeq(1:Q1,1);
        db_d2 = database.NTSeq(Q1+1:Q2,1);
        db_d3 = database.NTSeq(Q2+1:Q3,1);
        db_d4 = database.NTSeq(Q3+1:end,1);
        
        db_e1 = database.Header(1:Q2,1);
        db_e2 = database.Header(Q2+1:end,1);
        
        % saving the reading frames
        save(loc.a{1},"db_a1");
        save(loc.a{2},"db_a2");
        
        save(loc.b{1},"db_b1");
        save(loc.b{2},"db_b2");
        
        save(loc.c{1},"db_c1");
        save(loc.c{2},"db_c2");
        
        save(loc.d{1},"db_d1");
        save(loc.d{2},"db_d2");
        save(loc.d{3},"db_d3");
        save(loc.d{4},"db_d4");
        
        save(loc.e{1},"db_e1");
        save(loc.e{2},"db_e2");
        
        disp("Reading frames are saved");
        flag = 1; %% reading frames are generated
    elseif flag == 1 %% reading frames exists, loading them
        disp("Loading Reading frames ...")
        load(loc.a{1});
        load(loc.a{2});
        
        load(loc.b{1});
        load(loc.b{2});
        
        load(loc.c{1});
        load(loc.c{2});
        
        load(loc.d{1});
        load(loc.d{2});
        load(loc.d{3});
        load(loc.d{4});
        
        load(loc.e{1});
        load(loc.e{2});
        
        database.FrameOne = [db_a1;db_a2];
        database.FrameTwo = [db_b1;db_b2];
        database.FrameThree = [db_c1;db_c2];
        database.NTSeq = [db_d1;db_d2;db_d3;db_d4];
        database.Header = [db_e1;db_e2];
        
        n = 1;
        m = length(database.NTSeq);
        
        disp("Reading Frames are Loaded!")
    elseif flag == 2
        load(dirc.Output+"/"+result);
        database = db_standard;
        clear db_standard;
    end 
end