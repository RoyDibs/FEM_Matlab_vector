clear; close all; clc;

% specify problem domain
DOMAIN.xmin = 0; DOMAIN.xmax = 1; 
DOMAIN.ymin = 0; DOMAIN.ymax = 1; 
DOMAIN.L = DOMAIN.xmax-DOMAIN.xmin;
DOMAIN.H = DOMAIN.ymax-DOMAIN.ymin;

% create mesh
MESH.xdiv = 2; MESH.ydiv = 2;
MESH.type = 'bilin_quads';
[MESH] = mesh_rect_domain(DOMAIN,MESH);

MESH.x(5) = 0.7; MESH.y(5) = 0.7; MESH.z(5) = 0.0; 

% assign material properties
PARAMS.analysis_type = '2d_lin_elas';
if(strcmp(PARAMS.analysis_type,'2d_heat'))
    MATERIAL.kappa = eye(2);
elseif(strcmp(PARAMS.analysis_type,'2d_lin_elas'))
    PARAMS.twod_analysis_type = 'Plane_strain';
    MATERIAL.E = 1; MATERIAL.nu = 0.25;
else
    fprintf('errAnalysisType::Analysis type not supported\n');
end

% create data structures to store nodal coordinates and element
% connectivity
[NODE, ELEM, PARAMS, FE] = create_data_structures(MESH,PARAMS,MATERIAL);

% specify boundary conditions
[NODE] = specify_dbcs(NODE,DOMAIN);

% assemble system
[bigk,fext] = assemble_system(ELEM,NODE,FE);

% apply boundary conditions
[bigk,fext] = apply_bcs(bigk,fext,NODE);

% solve system
u_fem = bigk\fext

% postprocess results
postprocess_results_fem(u_fem,MESH);
