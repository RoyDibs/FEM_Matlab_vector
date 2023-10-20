function[bigk,fext] = assemble_global(elem,bigk,fext,ke,fe)

nlink = length(elem.nodes);
for jnod=1:nlink
    cg = elem.nodes(jnod)*2;
    ce = jnod*2;
    % Assemble global stiffness vector
    for inod=1:nlink
        rg = elem.nodes(inod)*2;
        re = inod*2;
        bigk(rg-1:rg,cg-1:cg) = bigk(rg-1:rg,cg-1:cg) + ke(re-1:re,ce-1:ce);
        % bigk(rg,cg) = bigk(rg,cg) + ke(re,ce);
    end
    % Assemble global force vector 
    fext(cg-1:cg) = fext(cg-1:cg) + fe(ce-1:ce);
end