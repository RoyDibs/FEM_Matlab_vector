function [bigk,fext] = assemble_system(ELEM,NODE,FE)

% initialize stiffness and force matrices
fext = zeros(length(NODE)*2,1);
bigk = zeros(length(NODE)*2,length(NODE)*2);

% assemble system
for ielem=1:length(ELEM)

    % evaluate element force vector
    [ke,fe] = get_element_stiffness_and_force(ELEM(ielem),NODE,FE);
        
    % assemble local system in global matrix
    [bigk,fext] = assemble_global(ELEM(ielem),...
        bigk,fext,ke,fe);
end

end