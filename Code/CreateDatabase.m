function db_out = CreateDatabase()
    % reading the fastafile of nucleotide Sequences to create the 
    % refernece database
    % @Param the directory of the fastafile
    
    global fasta flag m n dirc;
    
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
        disp("the size of the database after removing duplicated/animal sequences is "+numel(HeaderDb));
        
        disp("Generating Main Reading Frames for the input database ...")
        ProteinDbF1 = cellfun(@(x) nt2aa(x,'ACGTOnly',false,...
            'AlternativeStartCodons',false),SequenceDb,'UniformOutput',false);
        disp("Frame One is generated successfully");
        ProteinDbF2 = cellfun(@(x) nt2aa(x(1,2:end),'ACGTOnly',false,'AlternativeStartCodons',false),SequenceDb,'UniformOutput',false);
        disp("Frame Two is generated successfully");
        ProteinDbF3 = cellfun(@(x) nt2aa(x(1,3:end),'ACGTOnly',false,'AlternativeStartCodons',false),SequenceDb,'UniformOutput',false);
        disp("Frame Three is generated successfully");
        
        % Creating the database
        db_out.FrameOne =  ProteinDbF1;
        db_out.FrameTwo =  ProteinDbF2;
        db_out.FrameThree =  ProteinDbF3;
        db_out.NTSeq = SequenceDb;
        db_out.Header = HeaderDb;
        % adjusting the value of n and m after data curation and gap removal
        n = 1;
        m = length(db_out.NTSeq);
        
        clear ProteinDbF1 ProteinDbF2 ProteinDbF3 SequenceDb HeaderDb;
        %% Saving reading frames in smaller fragments
        disp("Saving the result in "+ dirc.Database);
        items = ceil(m/1000);
        sections = ceil(linspace(0,m,items));
        if items > 1
            for parts=2:items
               res =  dirc.Database + "/db_part_"+parts+".mat";
               db_parts = StructureCut(db_out,sections(parts-1)+1:sections(parts));
               save(res,"db_parts");
               clear db_parts;
            end
        else
            res =  dirc.Database + "/database.mat";
           save(res,"db_out");
           clear db_parts;
        end
        disp("Reading frames are saved");
        flag = 1; %% reading frames are generated
    elseif flag == 1 %% reading frames exists, loading them
        disp("Loading Reading frames ...")
        cd(dirc.Database);
        mat = dir('db_part_*.mat'); 
        for q = 1:length(mat) 
            S = load(mat(q).name); 
        end
        db_out = ConcatStruct(S);
        
        n = 1;
        m = length(db_out.NTSeq);
        
        disp("Reading Frames are Loaded!")
        cd(dirc.main);
    elseif flag == 2
        cd(dirc.Output)
        mat = dir('Result_db_*.mat');
        for q = 1:length(mat) 
            S = load(mat(q).name); 
        end
        db_out = ConcatStruct(S);
        n = 1;
        m = length(db_out.NTSeq);
        cd(dirc.main)
    end 
end