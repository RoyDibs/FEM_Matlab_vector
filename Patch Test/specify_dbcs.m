function [NODE] = specify_dbcs(NODE,DOMAIN)
for inod=1:length(NODE)
    % if(abs(NODE(inod).X(1)-DOMAIN.xmin) <=1e-12) || (abs(NODE(inod).X(1)-DOMAIN.xmax) <=1e-12) || (abs(NODE(inod).X(2)-DOMAIN.ymin) <=1e-12) || (abs(NODE(inod).X(2)-DOMAIN.ymax) <=1e-12)
    %     NODE(inod).u_is_fixed = 1;
    %     NODE(inod).u = NODE(inod).X(1)^2 + NODE(inod).X(2)^2;
    % end

    if(abs(NODE(inod).X(2)-DOMAIN.ymin) <=1e-12)
        NODE(inod).u_is_fixed(2) = 1;
        NODE(inod).u(2) = 0;
    end
    if(abs(NODE(inod).X(1)-DOMAIN.xmin) <=1e-12) && (abs(NODE(inod).X(2)-DOMAIN.ymin) <=1e-12)
        NODE(inod).u_is_fixed(1) = 1;
        NODE(inod).u(1) = 0;
    end
    if(abs(NODE(inod).X(2)-DOMAIN.ymax) <=1e-12)
        NODE(inod).u_is_fixed(2) = 1;
        NODE(inod).u(2) = 0.05;
    end

end
end