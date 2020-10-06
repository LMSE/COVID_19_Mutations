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
        n = 1;
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
        
        indx1 = cellfun(@(x) ismember('-',x),SequenceDb);
        SequenceDb = SequenceDb(~indx1);
        HeaderDb = HeaderDb(~indx1);
        indx2 = cellfun(@(x) ismember(' ',x),SequenceDb);
        HeaderDb = HeaderDb(~indx2);
        SequenceDb = SequenceDb(~indx2);
        clear indx1 indx2;
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
        flag = 1; %% reading frames are generated
        
        %% Saving reading frames
        db_a = database.FrameOne;
        db_b = database.FrameTwo;
        db_c = database.FrameThree;
        db_d1 = database.NTSeq(1:ceil(numel(db_a)/3),1);
        db_d2 = database.NTSeq(ceil(numel(db_a)/3)+1:ceil(numel(db_a)/3*2),1);
        db_d3 = database.NTSeq(ceil(numel(db_a)/3*2)+1:end,1);
        db_e = database.Header;
        
        % saving the reading frames
        save(loc.a,"db_a");
        save(loc.b,"db_b");
        save(loc.c,"db_c");
        save(loc.d{1},"db_d1");
        save(loc.d{2},"db_d2");
        save(loc.d{3},"db_d3");
        save(loc.e,"db_e");
        disp("Reading frames are saved");
        
    elseif flag == 1 %% reading frames exists, loading them
        disp("Loading Reading frames ...")
        load(loc.a);
        load(loc.b);
        load(loc.c);
        load(loc.d{1});
        load(loc.d{2});
        load(loc.d{3});
        load(loc.e);
        
        database.FrameOne = db_a;
        database.FrameTwo = db_b;
        database.FrameThree = db_c;
        database.NTSeq = [db_d1;db_d2;db_d3];
        database.Header = db_e;
        
        n = 1;
        m = length(database.NTSeq);
        
        disp("Reading Frames are Loaded!")
    elseif flag == 2
        load(dirc.Output+"/"+result);
        database = db_copy4;
        clear db_copy4;
    end 
end