function [bigk,fext] = apply_bcs(bigk,fext,NODE)
% apply_bcs: Modify the global stiffness and 
% force vector to enforce BCs
for inod=1:length(NODE)
    for i=1:2
        if(NODE(inod).u_is_fixed(i))
            inodd = inod * 2 - 2 + i;
            % Modify force vector
            for jnod=1:length(NODE)*2
                fext(jnod) = fext(jnod) - bigk(jnod,inodd)*NODE(inod).u(i);
            end
            fext(inodd) = NODE(inod).u(i);
            % clear row
            bigk(inodd,:) = zeros(1,length(NODE)*2);
            % clear column
            bigk(:,inodd) = zeros(length(NODE)*2,1);
            % set diagonal entry to 1
            bigk(inodd,inodd) = 1.0;
        end
    end
end

end