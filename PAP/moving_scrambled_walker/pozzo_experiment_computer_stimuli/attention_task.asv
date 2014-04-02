 function [oddstimuli , questions]=attention_task(stimuli)

%questa funzione crea una lista di al massimo tre stimoli che cambiano
%colore e al massimo 3 domande intercalate tra questi stimoli che cambiano
%colore

N_stimuli=stimuli;
N_oddstimuli=ceil(rand(1)*3);

switch N_oddstimuli
    case 1
        oddstimuli(1)=ceil(rand(1)*N_stimuli);
        aux=min([15 , N_stimuli-oddstimuli(1)]);
        question_delay=ceil(rand(1)*aux);
        questions=oddstimuli(1) + question_delay;
%         N_questions=1
%         disp('Ho completato case 1');
    case 2
        oddstimuli(1)=ceil(rand(1)*(N_stimuli/2));
        oddstimuli(2)=N_stimuli/2 + ceil(rand(1)*(N_stimuli/2));
        N_questions=ceil(rand(1)*2);
        switch N_questions
            case 1
                aux=min([15 , N_stimuli-oddstimuli(2)]);
                questions=oddstimuli(2)+floor(rand(1)*aux);
%                 disp('Ho completato case 2 1')
            case 2
                aux1=min([15 , oddstimuli(2)-oddstimuli(1)]);
                questions(1)=oddstimuli(1)+floor(rand(1)*aux1);
                aux2=min([15 , N_stimuli-oddstimuli(2)]);
                questions(2)=oddstimuli(2)+floor(rand(1)*aux2);
%                 disp('Ho completato case 2 2')
        end
        
    case 3
        oddstimuli(1)=ceil(rand(1)*(N_stimuli/3));
        oddstimuli(2)=N_stimuli/3 + ceil(rand(1)*(N_stimuli/3));
        oddstimuli(3)=2*N_stimuli/3 + ceil(rand(1)*(N_stimuli/3));
        N_questions=ceil(rand(1)*3);
        switch N_questions
            case 1 
%                 aux=min([15 , N_stimuli-oddstimuli(1)]);
                questions=oddstimuli(1)+floor(rand(1)*(N_stimuli-oddstimuli(1))); 
%                 disp('Ho completato case 3 1')
            case 2
                possible_placements=ceil(rand(1)*2);
                switch possible_placements
                    
                    case 1
                        %diciamo che questo caso corrisponde alle due
                        %domande collocate in posizioni [1 0 1]
                        questions(1)=oddstimuli(1)+floor(rand(1)*(oddstimuli(2)-oddstimuli(1)));
                        questions(2)=oddstimuli(3)+floor(rand(1)*(N_stimuli-oddstimuli(3)));
%                         disp('Ho completato case 3 2 1')
                    case 2                        
                        %diciamo che questo caso corrisponde alle due
                        %domande collocate in posizioni [0 1 1]
                        questions(1)=oddstimuli(2)+floor(rand(1)*(oddstimuli(3)-oddstimuli(2)));
                        questions(2)=oddstimuli(3)+floor(rand(1)*(N_stimuli-oddstimuli(3)));
%                         disp('Ho completato case 3 2 2')
                end
                        
            case 3
                questions(1)=oddstimuli(1)+floor(rand(1)*(oddstimuli(2)-oddstimuli(1)));
                questions(2)=oddstimuli(2)+floor(rand(1)*(oddstimuli(3)-oddstimuli(2)));
                questions(3)=oddstimuli(3)+floor(rand(1)*(N_stimuli-oddstimuli(3)));
%                 disp('Ho completato case 3 3')
        end
end
% N_oddstimuli
% N_questions
% oddstimuli
% questions
% if N_questions==2 & N_oddstimuli==3
% possible_placements
% else
%     possible_placements=1
% end
