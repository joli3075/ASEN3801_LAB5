%% header 
% saveFiguresToFolder - Saves all open figures to a specified folder as PNG files.
%
% Syntax: saveFiguresToFolder(FolderName)
%
% Inputs:
%   FolderName - A string specifying the destination folder where figures will be saved.
%
% Outputs:
%   None. The function saves figures directly to the specified folder.



FolderName = "./images";   % Your destination folder
mkdir(FolderName)

% Get all open figure handles
figHandles = findall(0, 'Type', 'figure');

% Loop through each figure handle
for i = 1:numel(figHandles)
    % Get the current figure
    currentFig = figHandles(i);

    % Construct a filename based on the figure number
    % You can modify this to include a custom prefix or other information
    filename = sprintf("./images/figure_%d.png", currentFig.Number);

    % Save the figure as a PNG file
    saveas(currentFig, filename);

    fprintf('Saved figure %d as %s\n', currentFig.Number, filename);
end