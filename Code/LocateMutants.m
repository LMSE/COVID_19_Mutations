function Mutant = LocateMutants(SetSeq ,AlignVector)
    global fasta
    tic
    check = {':',' '};
    AlignVector = cellfun(@(data) data{1} , AlignVector,'UniformOutput',false);
    Mutant.Loc = cellfun(@(data) regexp(data(2,:),strjoin(check,'|'))'  , AlignVector,'UniformOutput',false);
    Mutant.One = cellfun(@(data) data(1,regexp(data(2,:),strjoin(check,'|')))'  , AlignVector,'UniformOutput',false);
    Mutant.Two = cellfun(@(data) data(3,regexp(data(2,:),strjoin(check,'|')))'  , AlignVector,'UniformOutput',false);
    
    %% Reseting the Location
    lag = [];
    for i=1:length(AlignVector)
        lag = strfind(SetSeq,AlignVector{i}(1,1:5)); 
        if isempty(lag)
            disp("Brocken Sequences " + string(i));
            SetPoint = strfind(AlignVector{i}(1,1:5),"-");
            lag = strfind(SetSeq,AlignVector{i}(1,1:SetPoint(1)-1));
        end
        % adjustment of Pdb
        if isfile(fasta.pdb)
            pdb = fastaread(fasta.pdb);
            pdb_lag = strfind(pdb.Sequence,SetSeq)
            lag = lag +pdb_lag-1
        end
        Gaps = strfind(AlignVector{i}(1,:),'-')';
        OffSet = lag(1)-1;
        n = length(Mutant.Loc{i});
        unwanted_indx = [];
        for k=1:n
            if isempty( find(Gaps == Mutant.Loc{i}(k), 1))
                    GapsOffSet = length(Gaps( Gaps < Mutant.Loc{i}(k)));
                    Mutant.Loc{i}(k)=Mutant.Loc{i}(k)+ OffSet - GapsOffSet;
            else 
                    unwanted_indx = [unwanted_indx;k];
            end
        end
        Mutant.Loc{i}(unwanted_indx) = [];
        Mutant.One{i}(unwanted_indx) = [];
        Mutant.Two{i}(unwanted_indx) = [];
    end  
toc
end
