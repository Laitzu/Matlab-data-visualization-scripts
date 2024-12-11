% Script for visualizing 4 datasets at once

% Ask for folder where the 4 datasets are
dataFolder = uigetdir('..\Data\');

% Get all datafiles in the folder
dataFiles = dir(fullfile(dataFolder, '*.csv'));

% Initialize storage variables
datasets = cell(1, 4);
timeData = cell(1, 4);
vertAccData = cell(1, 4);
newTimeData = cell(1, 4);
samplingFrequencies = zeros(1, 4);

% For all 4 datafiles...
for i = 1:4
    datasets{i} = readtable(fullfile(dataFiles(i).folder, dataFiles(i).name));
    % Get time and vertical acceleration
    timeData{i} = datasets{i}{:,1};
    vertAccData{i} = datasets{i}{:,7};
    
    % Normalize time vector to start at 0
    timeData{i} = timeData{i} - timeData{i}(1);

    % Calculate sampling frequency
    timeDiffs = diff(timeData{i});                  % Get delta times
    averageInterval = mean(timeDiffs);              % Average delta time
    samplingFrequencies(i) = 1 / averageInterval;   % Get frequency

    % Generate new time axis based on sampling frequency
    numPoints = length(timeData{i});
    totalDuration = timeData{i}(end);
    newTimeData{i} = linspace(0, totalDuration, numPoints);

    % Filter unnecessary data, drop first few seconds of data
    % Using a logical array
    filterIdx = newTimeData{i} >= 3;
    newTimeData{i} = newTimeData{i}(filterIdx);
    vertAccData{i} = vertAccData{i}(filterIdx);
end

% Get maximum and minimum for graph limits
minY = min([min(vertAccData{1}), min(vertAccData{2}), min(vertAccData{3}), min(vertAccData{4})]);
maxY = max([max(vertAccData{1}), max(vertAccData{2}), max(vertAccData{3}), max(vertAccData{4})]);

% Plot vertical acceleration
figure('Position', [100, 100, 1400, 800]);

for i = 1:4
    subplot(4, 1, i);
    plot(newTimeData{i}, vertAccData{i});
    xlabel('Time (s)');
    ylabel('Vertical Acceleration (m/s²)');
    title(sprintf('Vertical Acceleration (%.0f Hz)', samplingFrequencies(i)));
    %ylim([minY, maxY]);
    grid on;
end