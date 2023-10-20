function [Dmat] = get_mat_tensor(MATERIAL,PARAMS)

if(strcmp(PARAMS.analysis_type,'2d_heat'))
    Dmat = MATERIAL.kappa;
elseif(strcmp(PARAMS.analysis_type,'2d_lin_elas'))
    E = MATERIAL.E; nu = MATERIAL.nu;
    if(strcmp(PARAMS.twod_analysis_type,'Plane_strain'))
        lambda = nu*E/((1+nu)*(1-2*nu));
        mu = E/(2*(1+nu));
        Dmat = [(lambda+2*mu), lambda,  0;
            lambda, (lambda+2*mu),  0;
            0,             0, mu];
    elseif(strcmp(PARAMS.twod_analysis_type,'Plane_stress'))
        fac = E/(1. - nu^2);
        Dmat = fac*[  1, nu,        0;
            nu,  1,        0;
            0,  0, (1-nu)/2];
    else
        fprintf('errAnalysisType::Analysis type not supported11\n');
    end
else
    fprintf('errAnalysisType::Analysis type not supported\n');
end