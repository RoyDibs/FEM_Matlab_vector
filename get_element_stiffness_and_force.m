function [ke,fe] = get_element_stiffness_and_force(elem,NODE,FE)

nlink = length(elem.nodes)*2; %link is 4 but no. of components is 4*2

fe = zeros(nlink,1); ke = zeros(nlink,nlink);
ngp = size(FE.N,2);

nodal_body_force = zeros(nlink,1);
for inod=1:length(elem.nodes)
    nodal_body_force(inod) = NODE(elem.nodes(inod)).body_force;
end

elem_volume = 0;
for i=1:ngp        
    
    N = [FE.N(1,i) 0 FE.N(2,i) 0 FE.N(3,i) 0 FE.N(4,i) 0; 
         0 FE.N(1,i) 0 FE.N(2,i) 0 FE.N(3,i) 0 FE.N(4,i);
         FE.N(1,i) FE.N(1,i) FE.N(2,i) FE.N(2,i) FE.N(3,i) FE.N(3,i) FE.N(4,i) FE.N(4,i)];

    gradN = [FE.dNdpsi(:,i) FE.dNdeta(:,i)];
    
    inv_jcob_mat = (1/elem.jcob(i,1))*[elem.ypsieta(i,2), -elem.xpsieta(i,2);
                    -elem.ypsieta(i,1), elem.xpsieta(i,1)];
    Nxy = gradN*inv_jcob_mat;

    B = [Nxy(1,1) 0 Nxy(2,1) 0 Nxy(3,1) 0 Nxy(4,1) 0;
        0 Nxy(1,2) 0 Nxy(2,2) 0 Nxy(3,2) 0 Nxy(4,2);
        Nxy(1,2) Nxy(1,1) Nxy(2,2) Nxy(2,1) Nxy(3,2) Nxy(3,1) Nxy(4,2) Nxy(4,1)];
    
    
    ke = ke + (B'*elem.Dmat*B)*(elem.jcob(i,1)) ;
    % fe = fe + elem.jcob(i,1)*(N'*N)*nodal_body_force;

    elem_volume = elem_volume + elem.jcob(i,1);
end

err_len = elem_volume-elem.volume;
if(abs(err_len)>1e-12)
    fprintf('len_chk_err: error in numerical integration\n');
end


