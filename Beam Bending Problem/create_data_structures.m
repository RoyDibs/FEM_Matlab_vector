function [NODE,ELEM,PARAMS,FE] = create_data_structures(MESH,PARAMS,MATERIAL)

PARAMS.nlink = 2;
PARAMS.ndof = 1;

% Nodal data structure
NODE(MESH.numnod) = struct('X', [], 'u_is_fixed', [], 'u', [],'body_force',[]);
for inod=1:MESH.numnod
    NODE(inod).X(1) = MESH.x(inod); 
    NODE(inod).X(2) = MESH.y(inod);
    NODE(inod).X(3) = MESH.z(inod); 
    NODE(inod).u_is_fixed = [0 0];
    NODE(inod).body_force = 0;
end

% Finite element library
FE = struct('gradN', [], 'N', []);
gauss_psi = [-1/sqrt(3); 1/sqrt(3); -1/sqrt(3); 1/sqrt(3)];
gauss_eta = [-1/sqrt(3); -1/sqrt(3); 1/sqrt(3); 1/sqrt(3)];

for igp=1:length(gauss_psi)

    FE.N(1,igp) = 0.5*(1-gauss_psi(igp))*0.5*(1-gauss_eta(igp));
    FE.N(2,igp) = 0.5*(1+gauss_psi(igp))*0.5*(1-gauss_eta(igp));
    FE.N(3,igp) = 0.5*(1+gauss_psi(igp))*0.5*(1+gauss_eta(igp));
    FE.N(4,igp) = 0.5*(1-gauss_psi(igp))*0.5*(1+gauss_eta(igp));

    FE.dNdpsi(1,igp) = 0.5*(1-gauss_eta(igp))*(-0.5); % dN1/dpsi at quadrature point igp
    FE.dNdpsi(2,igp) = 0.5*(1-gauss_eta(igp))*(0.5);  % dN2/dpsi at quadrature point igp
    FE.dNdpsi(3,igp) = 0.5*(1+gauss_eta(igp))*(0.5);  % dN3/dpsi at quadrature point igp
    FE.dNdpsi(4,igp) = 0.5*(1+gauss_eta(igp))*(-0.5); % dN4/dpsi at quadrature point igp

    FE.dNdeta(1,igp) = 0.5*(1-gauss_psi(igp))*(-0.5); % dN1/deta at quadrature point igp
    FE.dNdeta(2,igp) = 0.5*(1+gauss_psi(igp))*(-0.5); % dN2/deta at quadrature point igp
    FE.dNdeta(3,igp) = 0.5*(1+gauss_psi(igp))*(0.5);  % dN3/deta at quadrature point igp
    FE.dNdeta(4,igp) = 0.5*(1-gauss_psi(igp))*(0.5);  % dN4/deta at quadrature point igp

end


ELEM(MESH.numele) = struct('nodes', [], 'volume', [], 'Dmat', [], ...
    'jcob', [],'strain',[],'avg_strain',0,'xpsieta',[],'ypsieta',[]);

for ielem=1:length(ELEM)
    ELEM(ielem).nodes = MESH.nodes(:,ielem);
    [ELEM(ielem).Dmat] = get_mat_tensor(MATERIAL,PARAMS);
    [ELEM] = get_jcob(FE,ELEM,NODE,ielem);
end

end