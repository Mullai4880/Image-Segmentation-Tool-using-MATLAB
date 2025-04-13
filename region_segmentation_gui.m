function region_segmentation_gui()
    % Create main figure with a more professional look
    fig = figure('Name', 'Advanced Region Segmentation Tool', ...
                'Position', [100 100 1200 700], ...
                'MenuBar', 'none', ...
                'NumberTitle', 'off', ...
                'Color', [0.2 0.2 0.2]);  % Dark theme
    
    % Initialize global variables
    global originalImage segmentedImage threshold numClusters hasLoadedImage;
    originalImage = [];
    segmentedImage = [];
    threshold = 0.5;
    numClusters = 3;
    hasLoadedImage = false;
    
    % Initialize default colors for multi-threshold
    global regionColors;
    regionColors = {[1 0 0], [0 1 0], [0 0 1], [1 1 0], [1 0 1]};
    
    % Create panels with better organization
    leftPanel = uipanel(fig, 'Position', [0.01 0.02 0.58 0.96], ...
                       'BackgroundColor', [0.2 0.2 0.2], ...
                       'ForegroundColor', 'white', ...
                       'Title', 'Image View');
    
    rightPanel = uipanel(fig, 'Position', [0.60 0.02 0.39 0.96], ...
                        'BackgroundColor', [0.2 0.2 0.2], ...
                        'ForegroundColor', 'white', ...
                        'Title', 'Controls');
    
    % Create image axes with side-by-side view
    global originalAxes segmentedAxes;
    originalAxes = axes('Parent', leftPanel, ...
                       'Position', [0.02 0.1 0.46 0.85]);
    segmentedAxes = axes('Parent', leftPanel, ...
                        'Position', [0.52 0.1 0.46 0.85]);
    
    % Create controls
    controlsPanel = uipanel(rightPanel, ...
                          'Position', [0.05 0.5 0.9 0.45], ...
                          'BackgroundColor', [0.25 0.25 0.25], ...
                          'ForegroundColor', 'white', ...
                          'Title', 'Segmentation Controls');
    
    % Add Load Image Button
    uicontrol(controlsPanel, ...
             'Style', 'pushbutton', ...
             'String', 'Load Image', ...
             'Position', [10 250 170 30], ...
             'BackgroundColor', [0.3 0.3 0.3], ...
             'ForegroundColor', 'white', ...
             'Callback', @loadImageCallback);
         
    % Reset to Test Pattern button
    uicontrol(controlsPanel, ...
             'Style', 'pushbutton', ...
             'String', 'Reset to Test Pattern', ...
             'Position', [190 250 170 30], ...
             'BackgroundColor', [0.3 0.3 0.3], ...
             'ForegroundColor', 'white', ...
             'Callback', @loadTestPattern);
    
    % Method selection
    global methodDropdown;
    uicontrol(controlsPanel, ...
             'Style', 'text', ...
             'String', 'Segmentation Method:', ...
             'Position', [10 220 170 20], ...
             'BackgroundColor', [0.25 0.25 0.25], ...
             'ForegroundColor', 'white');
         
    methodDropdown = uicontrol(controlsPanel, ...
             'Style', 'popupmenu', ...
             'String', {'Basic Threshold', 'Multi-threshold'}, ...
             'Position', [10 200 170 22], ...
             'BackgroundColor', 'white', ...
             'Callback', @methodCallback);
    
    % Threshold slider and label
    uicontrol(controlsPanel, ...
             'Style', 'text', ...
             'String', 'Threshold:', ...
             'Position', [10 170 170 20], ...
             'BackgroundColor', [0.25 0.25 0.25], ...
             'ForegroundColor', 'white');
         
    global thresholdSlider thresholdText;
    thresholdSlider = uicontrol(controlsPanel, ...
             'Style', 'slider', ...
             'Min', 0, 'Max', 1, ...
             'Value', threshold, ...
             'Position', [10 150 170 22], ...
             'SliderStep', [0.01 0.1], ...
             'Callback', @thresholdCallback);
    
    thresholdText = uicontrol(controlsPanel, ...
             'Style', 'text', ...
             'String', sprintf('%.2f', threshold), ...
             'Position', [190 150 50 22], ...
             'BackgroundColor', [0.25 0.25 0.25], ...
             'ForegroundColor', 'white');
    
    % Clusters slider and label
    uicontrol(controlsPanel, ...
             'Style', 'text', ...
             'String', 'Number of Clusters:', ...
             'Position', [10 120 170 20], ...
             'BackgroundColor', [0.25 0.25 0.25], ...
             'ForegroundColor', 'white');
         
    global clustersSlider clustersText;
    clustersSlider = uicontrol(controlsPanel, ...
             'Style', 'slider', ...
             'Min', 2, 'Max', 5, ...
             'Value', numClusters, ...
             'Position', [10 100 170 22], ...
             'SliderStep', [1/3 1/3], ...
             'Callback', @clustersCallback);
    
    clustersText = uicontrol(controlsPanel, ...
             'Style', 'text', ...
             'String', sprintf('%d', numClusters), ...
             'Position', [190 100 50 22], ...
             'BackgroundColor', [0.25 0.25 0.25], ...
             'ForegroundColor', 'white');
             
    % Add Save/Export buttons
    uicontrol(controlsPanel, ...
             'Style', 'pushbutton', ...
             'String', 'Save Result', ...
             'Position', [10 50 170 30], ...
             'BackgroundColor', [0.3 0.3 0.3], ...
             'ForegroundColor', 'white', ...
             'Callback', @saveResult);

    uicontrol(controlsPanel, ...
             'Style', 'pushbutton', ...
             'String', 'Export Histogram', ...
             'Position', [190 50 170 30], ...
             'BackgroundColor', [0.3 0.3 0.3], ...
             'ForegroundColor', 'white', ...
             'Callback', @exportHistogram);
    
    % Add analysis panel
    analysisPanel = uipanel(rightPanel, ...
                          'Position', [0.05 0.05 0.9 0.4], ...
                          'BackgroundColor', [0.25 0.25 0.25], ...
                          'ForegroundColor', 'white', ...
                          'Title', 'Analysis');
    
    % Add histogram axes
    global histAxes;
    histAxes = axes('Parent', analysisPanel, ...
                   'Position', [0.1 0.2 0.8 0.7], ...
                   'Color', [0.3 0.3 0.3]);
    
    % Create initial test pattern
    createTestPattern();
    updateSegmentation();
    
    % Set close request function
    set(fig, 'CloseRequestFcn', @closeFigure);
end

function loadImageCallback(~, ~)
    global originalImage hasLoadedImage;
    [filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif', 'Image Files (*.jpg,*.png,*.bmp,*.tif)';
                                    '*.*', 'All Files (*.*)'});
    if filename ~= 0
        try
            img = imread(fullfile(pathname, filename));
            if size(img, 3) > 1
                img = rgb2gray(img);  % Convert to grayscale if it's RGB
            end
            originalImage = img;
            hasLoadedImage = true;
            updateSegmentation();
        catch
            errordlg('Error loading image!', 'Error');
        end
    end
end

function loadTestPattern(~, ~)
    global hasLoadedImage;
    if hasLoadedImage
        choice = questdlg('Do you want to reset to the test pattern? This will replace your loaded image.', ...
            'Confirm Reset', ...
            'Yes', 'No', 'No');
        if strcmp(choice, 'No')
            return;
        end
    end
    
    createTestPattern();
    hasLoadedImage = false;
    updateSegmentation();
end

function createTestPattern()
    global originalImage;
    [X, Y] = meshgrid(1:400, 1:400);
    center1 = [200, 200];
    center2 = [100, 200];
    center3 = [300, 200];
    
    % Create multiple circles
    circle1 = sqrt((X-center1(1)).^2 + (Y-center1(2)).^2) < 80;
    circle2 = sqrt((X-center2(1)).^2 + (Y-center2(2)).^2) < 40;
    circle3 = sqrt((X-center3(1)).^2 + (Y-center3(2)).^2) < 60;
    
    % Add some noise and gradients
    noise = randn(400, 400) * 0.1;
    gradient = repmat(linspace(0, 1, 400), 400, 1);
    
    % Combine patterns
    img = (circle1 + circle2 + circle3) * 0.5 + noise + gradient * 0.3;
    img = (img - min(img(:))) / (max(img(:)) - min(img(:)));
    originalImage = uint8(img * 255);
end

function updateSegmentation()
    global originalImage segmentedImage threshold numClusters methodDropdown;
    global originalAxes segmentedAxes histAxes;
    
    if isempty(originalImage)
        return;
    end
    
    % Calculate and display histogram
    [counts, centers] = calculateHistogram(originalImage);
    cla(histAxes);
    
    % Plot histogram bars
    bar(histAxes, centers, counts, 'FaceColor', [0.7 0.7 0.7]);
    hold(histAxes, 'on');
    
    % Add threshold lines
    if strcmp(methodDropdown.String{methodDropdown.Value}, 'Basic Threshold')
        % Single threshold line
        threshLine = threshold * 255;
        plot(histAxes, [threshLine threshLine], [0 max(counts)], 'r-', 'LineWidth', 2);
        text(threshLine, max(counts), sprintf('Threshold\n%.2f', threshold), ...
             'Color', 'red', 'HorizontalAlignment', 'left', ...
             'VerticalAlignment', 'top');
    else
        % Multiple threshold lines with different colors
        thresholds = linspace(0, 255, numClusters+1);
        colors = {'r', 'g', 'b', 'y', 'm'};  % Colors for different thresholds
        for i = 2:length(thresholds)-1
            plot(histAxes, [thresholds(i) thresholds(i)], [0 max(counts)], ...
                 'Color', colors{i-1}, 'LineStyle', '-', 'LineWidth', 2);
            text(thresholds(i), max(counts)*(1-0.1*(i-1)), ...
                 sprintf('T%d: %.0f', i-1, thresholds(i)), ...
                 'Color', colors{i-1}, 'HorizontalAlignment', 'left', ...
                 'VerticalAlignment', 'top');
        end
    end
    
    hold(histAxes, 'off');
    title(histAxes, 'Image Histogram', 'Color', 'white');
    set(histAxes, 'XColor', 'white', 'YColor', 'white');
    xlabel(histAxes, 'Intensity', 'Color', 'white');
    ylabel(histAxes, 'Frequency', 'Color', 'white');
    
    % Perform segmentation
    [h, w] = size(originalImage);
    segmentedImage = zeros(h, w, 3);
    normalizedImg = double(originalImage) / 255;
    
    if strcmp(methodDropdown.String{methodDropdown.Value}, 'Basic Threshold')
        mask = normalizedImg > threshold;
        segmentedImage(:,:,1) = mask;
        segmentedImage(:,:,2) = mask;
        segmentedImage(:,:,3) = mask;
    else
        performMultiThreshold(normalizedImg);
    end
    
    % Display results
    imshow(originalImage, 'Parent', originalAxes);
    title(originalAxes, 'Original Image', 'Color', 'white');
    
    imshow(segmentedImage, 'Parent', segmentedAxes);
    title(segmentedAxes, sprintf('Segmented Image (Threshold: %.2f)', threshold), 'Color', 'white');
end

function [counts, centers] = calculateHistogram(img)
    edges = linspace(0, 255, 51);
    centers = (edges(1:end-1) + edges(2:end)) / 2;
    counts = histcounts(double(img(:)), edges);
end

function performMultiThreshold(normalizedImg)
    global numClusters segmentedImage regionColors;
    n = round(numClusters);
    thresholds = linspace(0, 1, n+1);
    
    segmentedImage = zeros(size(normalizedImg,1), size(normalizedImg,2), 3);
    
    for i = 1:n
        if i == 1
            mask = normalizedImg <= thresholds(i+1);
        elseif i == n
            mask = normalizedImg > thresholds(i);
        else
            mask = normalizedImg > thresholds(i) & normalizedImg <= thresholds(i+1);
        end
        applyColors(mask, i);
    end
end

function applyColors(mask, regionIndex)
    global segmentedImage regionColors;
    if nargin < 2
        regionIndex = 1;
    end
    for c = 1:3
        temp = segmentedImage(:,:,c);
        temp(mask) = regionColors{regionIndex}(c);
        segmentedImage(:,:,c) = temp;
    end
end

function methodCallback(source, ~)
    global methodDropdown;
    if source.Value ~= methodDropdown.Value
        choice = questdlg('Changing segmentation method will reset current settings. Continue?', ...
            'Confirm Method Change', ...
            'Yes', 'No', 'No');
        if strcmp(choice, 'No')
            source.Value = methodDropdown.Value;
            return;
        end
    end
    updateSegmentation();
end

function thresholdCallback(source, ~)
    global threshold thresholdText;
    threshold = source.Value;
    set(thresholdText, 'String', sprintf('%.2f', threshold));
    updateSegmentation();
end

function clustersCallback(source, ~)
    global numClusters clustersText;
    newValue = round(source.Value);
    if newValue ~= numClusters
        choice = questdlg(sprintf('Change number of clusters to %d?', newValue), ...
            'Confirm Clusters Change', ...
            'Yes', 'No', 'No');
        if strcmp(choice, 'No')
            source.Value = numClusters;
            return;
        end
        numClusters = newValue;
        set(clustersText, 'String', sprintf('%d', numClusters));
        updateSegmentation();
    end
end

function saveResult(~, ~)
    global segmentedImage;
    if isempty(segmentedImage)
        errordlg('No image to save!', 'Error');
        return;
    end
    
    [filename, pathname] = uiputfile({'*.png','PNG Image (*.png)';
                                    '*.jpg','JPEG Image (*.jpg)';
                                    '*.tif','TIFF Image (*.tif)'}, ...
                                    'Save Segmented Image As');
    if filename ~= 0
        try
            imwrite(segmentedImage, fullfile(pathname, filename));
            msgbox('Image saved successfully!', 'Success');
        catch
            errordlg('Error saving image!', 'Error');
        end
    end
end

function exportHistogram(~, ~)
    global histAxes;
    [filename, pathname] = uiputfile({'*.png','PNG Image (*.png)';
                                    '*.jpg','JPEG Image (*.jpg)';
                                    '*.fig','MATLAB Figure (*.fig)'}, ...
                                    'Export Histogram As');
    if filename ~= 0
        try
            fig = figure('Visible', 'off');
            newAxes = copyobj(histAxes, fig);
            set(newAxes, 'Position', get(groot, 'DefaultAxesPosition'));
            [~, ~, ext] = fileparts(filename);
            if strcmp(ext, '.fig')
                savefig(fig, fullfile(pathname, filename));
            else
                print(fig, fullfile(pathname, filename), '-dpng', '-r300');
            end
            close(fig);
            msgbox('Histogram exported successfully!', 'Success');
        catch
            errordlg('Error exporting histogram!', 'Error');
        end
    end
end

function closeFigure(src, ~)
    choice = questdlg('Are you sure you want to close the application?', ...
        'Close Application', ...
        'Yes', 'No', 'No');
    if strcmp(choice, 'Yes')
        delete(src);
    end
end
