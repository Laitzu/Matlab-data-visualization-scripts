% Script for comparing horizontal and angled phone position

% Filepaths
horizontalFile = '';
angledFile = '';

% Load data from files in to tables
horizontalData = readtable(horizontalFile);
angledData = readtable(angledFile);

% Extract vertical acceleration from files
vertAccHorizontal = horizontalData{:,7};
vertAccAngled = angledData{:,7};

% Calculate the sampling frequency of the datasets
timeDifferences = diff(horizontalData{:,1});    % Find all delta times
averageInterval = mean(timeDifferences);        % Get average time interval (delta time)
samplingFrequency = 1 / averageInterval;        % Calculate frequency

disp(['Sampling frequency: ', num2str(samplingFrequency), ' Hz']);

% Create time axis that starts from 0 for both of the datasets
timeHorizontal = linspace(0, length(vertAccHorizontal) / samplingFrequency, length(vertAccHorizontal));
timeAngled = linspace(0, length(vertAccAngled) / samplingFrequency, length(vertAccAngled));

% Get maximum and minimum y values for limits
minY = min([min(vertAccHorizontal), min(vertAccAngled)]);
maxY = max([max(vertAccHorizontal), max(vertAccAngled)]);

% Plot vertical acc with respect to time
% Also the frequency distribution of acceleration
figure('Position', [100, 100, 1400, 800]);

% Comparison of vertical acceleration vs time
subplot(2, 2, 1);
hold on;
plot(timeHorizontal, vertAccHorizontal, 'b');
xlabel('Time (s)');
ylabel('Vertical acceleration (m/s²)');
title(sprintf('Horizontal phone, %.0f Hz', samplingFrequency));
legend('Horizontal');
ylim([minY, maxY]);
grid on;
hold off;

subplot(2, 2, 2);
hold on;
plot(timeAngled, vertAccAngled, 'r');
xlabel('Time (s)');
ylabel('Vertical acceleration (m/s²)');
title(sprintf('Angled phone, %.0f Hz', samplingFrequency));
legend('Angled');
ylim([minY, maxY]);
grid on;
hold off;

% Frequency distribution

% Define bucket edges
bucketEdges = -10:0.5:10;   % Bucket size now 0.5 m/s^2
% Get bucket center locations
bucketCenters = (bucketEdges(1:end-1) + bucketEdges(2:end)) / 2;

% Count frequencies for horizontal data using histcounts
horizontalCounts = histcounts(vertAccHorizontal, bucketEdges, 'Normalization', 'percentage');

% Count frequencies for angled data using histcounts
angledCounts = histcounts(vertAccAngled, bucketEdges, 'Normalization', 'percentage');

% Plot the frequency distribution for both datasets
subplot(2, 2, [3 4]);
hold on;
bar(bucketCenters, horizontalCounts, 'FaceColor', 'b', 'FaceAlpha', 0.6, 'BarWidth', 0.9);
bar(bucketCenters, angledCounts, 'FaceColor', 'r', 'FaceAlpha', 0.6, 'BarWidth', 0.45);
xlabel('Vertical Acceleration (m/s²)');
ylabel('Frequency');
title(sprintf('Frequency distribution of vertical acceleration, %.0f Hz', samplingFrequency));
legend({'Horizontal', 'Angled'});
grid on;
hold off;



% Standard deviation easily calculated using built-in functions
disp(['Standard deviation (Horizontal): ', num2str(std(vertAccHorizontal))]);
disp(['Standard deviation (Angled): ', num2str(std(vertAccAngled))]);

% Also average acceleration (from absolute acceleration values)
disp(['Average acceleration (Horizontal): ', num2str(mean(abs(vertAccHorizontal)))])
disp(['Average acceleration (Angled): ', num2str(mean(abs(vertAccAngled)))])