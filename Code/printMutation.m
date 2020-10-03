function [t2,t5] = printMutation(ScoreVector,Mutant,DateVectore,CountryVector, HeaderVector)
t2 = cell2table(cell(0,8), 'VariableNames',{'Score'...
    ,'seqId','Wild_type_strand','Mutant_Strand'...
                ,'Location','Date','Country','Header'});
t5 = cell2table(cell(0,1),'VariableNames',{'Non_mutations'});
for i=1:length(ScoreVector)
        if ~isempty(Mutant.Loc{i})
                Wild_type_strand = string(Mutant.One{i});
                Mutant_Strand = string(Mutant.Two{i});
                Location = string(Mutant.Loc{i});
                Score = cell(length(Wild_type_strand),1);
                seqId = Score;
                Date = Score;
                Country = Score;
                Header = Score;
                for j=1:length(Wild_type_strand)
                    Score{j} = string(ScoreVector(i));
                    seqId{j} = string(i);
                    Date{j} = string(DateVectore(i));
                    Country{j} = string(CountryVector(i));
                    Header{j} = string(HeaderVector(i));
                end
                Score = vertcat(Score{:});
                seqId = vertcat(seqId{:});
                Date = vertcat(Date{:});
                Country = vertcat(Country{:});
                Header = vertcat(Header{:});
                 t1 = table(Score,seqId,Mutant_Strand,Wild_type_strand...
                ,Location,Date,Country, Header);
                t2 = [t2;t1]; 
        else
                t4 = table({"Sequence_"+int2str(i)},'VariableName',{'Non_mutations'});
                t5 = [t5;t4];
                
        end
end
t2 = sortrows(t2,[1,2]);
t3 = array2table(linspace(1,size(t2,1),size(t2,1))'...
    , 'VariableNames',{'row'});
t2 = [t3 t2];
t6 = array2table(linspace(1,size(t5,1),size(t5,1))'...
    , 'VariableNames',{'row'});
t5 = [t6,t5];
end
