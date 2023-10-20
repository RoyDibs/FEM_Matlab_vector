function  postprocess_results_fem(u_fem,MESH)

% p = 1;
% E = 1000;
% h = 4;
% L = 16;
% nu = 0.6;
% 
% u_exact(:,1) = ((2*p)/(E*h))* MESH.x * MESH.y;
% u_exact(:,2) = ((-p)/(E*h))*(MESH.x.^2 - nu * MESH.y.^2);


%Reshaping the x,y grid
X = reshape(MESH.x,MESH.xdiv+1,MESH.ydiv+1);
Y = reshape(MESH.y,MESH.xdiv+1,MESH.ydiv+1);
% Z_exactx = reshape(u_exact(:,1),MESH.xdiv+1,MESH.ydiv+1);
% Z_exacty = reshape(u_exact(:,2),MESH.xdiv+1,MESH.ydiv+1);
Z_fem = reshape(u_fem,2,MESH.numnod)';
zfemx = reshape(Z_fem(:,1),MESH.xdiv+1,MESH.ydiv+1);
zfemy = reshape(Z_fem(:,2),MESH.xdiv+1,MESH.ydiv+1);

% p = [MESH.x ,MESH.y ];
% p2 = [MESH.x + Z_fem(:,1) ,MESH.y + Z_fem(:,2)];
% 
% [k1,av1] = convhull(p);
% [k2,av2] = convhull(p2);
% 
% 
% %%Plotting
% figure
% 
% 
% plot(p(k1,1),p(k1,2))
% hold on 
% scatter(X+zfemx,Y+zfemy)
% plot(p2(k2,1),p2(k2,2))
% scatter(X,Y)


% % Create the first subplot: Exact solution
% subplot(1,2,1);
% surf(X,Y,Z_exactx,'EdgeColor','none'); % Remove the edges of the surface
% colormap(jet); % Use the 'jet' color map
% colorbar();
% xlabel('x');
% ylabel('y');
% zlabel('u_{exact}');
% lighting gouraud; % Use gouraud lighting
% title('Exact solution');

% Create the second subplot: FEM solution
% subplot(1,2,2);
% figure(2)
% surf(X,Y,zfemx,'EdgeColor','none'); % Remove the edges of the surface
% colormap(jet); % Use the 'jet' color map
% colorbar();
% xlabel('x');
% ylabel('y');
% zlabel('u_fem');
% lighting gouraud; % Use gouraud lighting
% title('FEM solution');

% % Create a figure for the FEM solution
% figure(3);
% surf(X, Y, zfemy, 'EdgeColor', 'none');
% colormap(jet);
% colorbar;
% xlabel('x');
% ylabel('y');
% zlabel('u_{fem}');
% lighting gouraud;
% title('FEM Solution');
% 
% % Customize the appearance of the figure
% axis tight; % Fit the axis limits to the data
% view(3); % Set the view to 3D

% Create a figure for the FEM solution
figure(1);
subplot(2,1,1);
contourf(X, Y, zfemy, 20, 'EdgeColor', 'none'); % Adjust the number of contour levels (20 in this example)
colormap(jet);
colorbar;
xlabel('x');
ylabel('y');
title('FEM Solution (u_{y})');

% Create a figure for the FEM solution
subplot(2,1,2);
contourf(X, Y, zfemx, 20, 'EdgeColor', 'none'); % Adjust the number of contour levels (20 in this example)
colormap(jet);
colorbar;
xlabel('x');
ylabel('y');
title('FEM Solution (u_{x})');

% Customize the appearance of the figure
axis tight; % Fit the axis limits to the data


p = [MESH.x, MESH.y];
p2 = [MESH.x + Z_fem(:, 1), MESH.y + Z_fem(:, 2)];

[k1, av1] = convhull(p);
[k2, av2] = convhull(p2);

% Create a figure and set the axis limits
figure(2)
axis equal           % Make the axes scale equally
axis tight           % Fit the axis limits to the data
grid on              % Show grid lines

% Plot the convex hull of the initial points (Set 2)
plot(p(k2, 1), p(k2, 2), 'b', 'LineWidth', 2)
hold on

% Scatter plot for the initial points (Set 2)
scatter(X, Y, 50, 'b', 'filled', 'MarkerEdgeColor', 'k')

% Plot the convex hull of the deformed points (Set 1)
plot(p2(k1, 1), p2(k1, 2), 'r', 'LineWidth', 2)

% Scatter plot for the deformed points (Set 1)
scatter(X + zfemx, Y + zfemy, 50, 'r', 'filled', 'MarkerEdgeColor', 'k')

% Add labels and title
xlabel('X-axis')
ylabel('Y-axis')
title('Nodes after deformation')

% Calculate label positions
labelPosSet2 = [mean(p(k2, 1)), mean(p(k2, 2))];
labelPosSet1 = [mean(p2(k1, 1)), mean(p2(k1, 2))];

% Add labels to indicate the sets
text(labelPosSet2(1), labelPosSet2(2) + 0.1, 'Initial Points', 'Color', 'b', 'FontSize', 12, 'FontWeight', 'bold')
text(labelPosSet1(1), labelPosSet1(2) - 0.1, 'Deformed Points', 'Color', 'r', 'FontSize', 12, 'FontWeight', 'bold')

% Adjust the plot appearance
set(gca, 'FontName', 'Arial', 'FontSize', 12)
set(gcf, 'Color', 'w')

hold off




% Calculate the L2 error between u_exact and u_fem
% l2_error = norm(u_exact - u_fem);
% disp("L-2 error is: \n");
% disp(l2_error);
% end