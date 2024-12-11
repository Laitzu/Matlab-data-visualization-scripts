% Script for comparing difference in bicycles

% Filepaths
bike1File = '';
bike2File = '';

% Load data in to tables
bike1Data = readtable(bike1File);
bike2Data = readtable(bike2File);

% Extract vertical acceleration (vertAcc) data from tables
vertAccBike1 = bike1Data{:,7};
vertAccBike2 = bike2Data{:,7};

% Get maximum and minimum for graph limits
minY = min([min(vertAccBike1), min(vertAccBike2)]);
maxY = max([max(vertAccBike1), max(vertAccBike2)]);

% Get time columns
timeBike1 = bike1Data{:,1};
timeBike2 = bike2Data{:,1};

% Calculate sampling frequency for Bike 1
timeDiffsBike1 = diff(timeBike1);                  % Get delta times
averageIntervalBike1 = mean(timeDiffsBike1);       % Get average delta time
FsBike1 = 1 / averageIntervalBike1;                % Calculate frequency
% Calculate sampling frequency for Bike 2
timeDiffsBike2 = diff(timeBike2);
averageIntervalBike2 = mean(timeDiffsBike2);
FsBike2 = 1 / averageIntervalBike2;

disp(['Estimated sampling frequency for Bike 1: ', num2str(FsBike1), ' Hz']);
disp(['Estimated sampling frequency for Bike 2: ', num2str(FsBike2), ' Hz']);

% Create time axes starting from 0 for both datasets
totTimeBike1 = timeBike1(end) - timeBike1(1);
totTimeBike2 = timeBike2(end) - timeBike2(1);
newTimeBike1 = linspace(0, totTimeBike1, length(timeBike1));
newTimeBike2 = linspace(0, totTimeBike2, length(timeBike2));

% Plot vertical acceleration over time for both datasets
figure('Position', [100, 100, 1400, 800]);

% Comparison of the vertical acceleration with respect to time for bike 1
subplot(2, 2, 1);
plot(newTimeBike1, vertAccBike1, 'b');
xlabel('Time (s)');
ylabel('Vertical Acceleration (m/s²)');
title(sprintf('Mountain bike vertical acceleration (%.0f Hz)', FsBike1));
ylim([minY, maxY]);
grid on;

% Comparison of the vertical acceleration with respect to time for bike 2
subplot(2, 2, 2);
plot(newTimeBike2, vertAccBike2, 'r');
xlabel('Time (s)');
ylabel('Vertical Acceleration (m/s²)');
title(sprintf('"Regular" bike vertical acceleration (%.0f Hz)', FsBike1));
ylim([minY, maxY]);
grid on;

% Define bucket edges for frequency distribution
bucketEdges = -15:0.5:15;   % Bucket size now 0.5 m/s^2
bucketCenters = (bucketEdges(1:end-1) + bucketEdges(2:end)) / 2;

% Count frequencies for both datasets
bike1Counts = histcounts(vertAccBike1, bucketEdges, 'Normalization', 'percentage');
bike2Counts = histcounts(vertAccBike2, bucketEdges, 'Normalization', 'percentage');

% Plot frequency distribution
subplot(2, 2, [3, 4]);
hold on;
bar(bucketCenters, bike1Counts, 'FaceColor', 'b', 'FaceAlpha', 0.6, 'BarWidth', 0.9);
bar(bucketCenters, bike2Counts, 'FaceColor', 'r', 'FaceAlpha', 0.6, 'BarWidth', 0.45);
xlabel('Vertical Acceleration (m/s²)');
ylabel('Frequency');
title('Frequency distribution of vertical acceleration');
legend({'Bike 1', 'Bike 2'});
grid on;
hold off;

% Standard deviation easily calculated using built-in functions
disp(['Standard Deviation (Bike 1): ', num2str(std(vertAccBike1))]);
disp(['Standard Deviation (Bike 2): ', num2str(std(vertAccBike2))]);

% Also mean
disp(['Average acceleration (Bike 1): ', num2str(mean(abs(vertAccBike1)))])
disp(['Average acceleration (Bike 2): ', num2str(mean(abs(vertAccBike2)))])
