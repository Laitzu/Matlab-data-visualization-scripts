% Script for comparing datasets of different sampling frequencies

% Filepaths
dataset1File = '';
dataset2File = '';

% Load data into tables
dataset1Data = readtable(dataset1File);
dataset2Data = readtable(dataset2File);

% Extract vertical acceleration
vertAcc1 = dataset1Data{:,7};
vertAcc2 = dataset2Data{:,7};

% Extract time columns
time1 = dataset1Data{:,1};
time2 = dataset2Data{:,1};

% Calculate sampling frequency
timeDiffs1 = diff(time1);                  % Get delta times
averageInterval1 = mean(timeDiffs1);       % Average delta time
Fs1 = 1 / averageInterval1;                % Sampling frequency

timeDiffs2 = diff(time2);
averageInterval2 = mean(timeDiffs2);
Fs2 = 1 / averageInterval2;

disp(['Estimated sampling frequency for Dataset 1: ', num2str(Fs1), ' Hz']);
disp(['Estimated sampling frequency for Dataset 2: ', num2str(Fs2), ' Hz']);

% Create time axes starting from 0 for both datasets
totTime1 = time1(end) - time1(1);
totTime2 = time2(end) - time2(1);
newTime1 = linspace(0, totTime1, length(time1));
newTime2 = linspace(0, totTime2, length(time2));

% Get maximum and minimum for y limits
minY = min([min(vertAcc1), min(vertAcc2)]);
maxY = max([max(vertAcc1), max(vertAcc2)]);

% Get maximum absolute value from both datasets for normalizing to -1 and 1
maxAbsDataset1 = max(abs(vertAcc1));
maxAbsDataset2 = max(abs(vertAcc2));

% Create normalized datasets (now between -1 and 1)
normalizedVertAcc1 = vertAcc1 / maxAbsDataset1;
normalizedVertAcc2 = vertAcc2 / maxAbsDataset2;

% Plot vertical acceleration with respect to time
figure('Position', [100, 100, 1400, 800]);

% Dataset 1 normalized vertical acceleration
subplot(2, 2, 1);
plot(newTime1, normalizedVertAcc1, 'b');
xlabel('Time (s)');
ylabel('Vertical Acceleration (m/s²)');
title(sprintf('Normalized Vertical Acceleration (Frequency %.0f Hz)', Fs1));
%ylim([-1, 1]);
grid on;

% Dataset 2 normalized vertical acceleration
subplot(2, 2, 2);
plot(newTime2, normalizedVertAcc2, 'r');
xlabel('Time (s)');
ylabel('Vertical Acceleration (m/s²)');
title(sprintf('Normalized Vertical Acceleration (Frequency %.0f Hz)', Fs2));
%ylim([minY, maxY]);
grid on;

% Frequency distribution

% Define bucket edges
bucketEdges = -15:0.5:15;   % Bucket size now 0.5 m/s²
bucketCenters = (bucketEdges(1:end-1) + bucketEdges(2:end)) / 2;

% Count frequencies
dataset1Counts = histcounts(vertAcc1, bucketEdges, 'Normalization', 'percentage');
dataset2Counts = histcounts(vertAcc2, bucketEdges, 'Normalization', 'percentage');

% Plot frequency distribution
subplot(2, 2, [3, 4]);
hold on;
bar(bucketCenters, dataset1Counts, 'FaceColor', 'b', 'FaceAlpha', 0.6, 'BarWidth', 0.9);
bar(bucketCenters, dataset2Counts, 'FaceColor', 'r', 'FaceAlpha', 0.6, 'BarWidth', 0.45);
xlabel('Vertical Acceleration (m/s²)');
ylabel('Frequency %');
title('Frequency Distribution of Vertical Acceleration');
legend({sprintf('%.0f Hz', Fs1), sprintf('%.0f Hz', Fs2)});
grid on;
hold off;

% Plot vertical acceleration with respect to time
figure('Position', [100, 100, 1400, 800]);

% Dataset 1 vertical acceleration
subplot(2, 2, 1);
plot(newTime1, vertAcc1, 'b');
xlabel('Time (s)');
ylabel('Vertical Acceleration (m/s²)');
title(sprintf('Vertical Acceleration (Frequency %.0f Hz)', Fs1));
ylim([minY, maxY]);
grid on;

% Dataset 2 vertical acceleration
subplot(2, 2, 2);
plot(newTime2, vertAcc2, 'r');
xlabel('Time (s)');
ylabel('Vertical Acceleration (m/s²)');
title(sprintf('Vertical Acceleration (Frequency %.0f Hz)', Fs2));
ylim([minY, maxY]);
grid on;

% Standard deviation easily calculated using built-in functions
disp(['Standard Deviation for Dataset 1: ', num2str(std(vertAcc1))]);
disp(['Standard Deviation for Dataset 2: ', num2str(std(vertAcc2))]);

% Also mean
disp(['Average acceleration (Lower frequency): ', num2str(mean(abs(vertAcc1)))])
disp(['Average acceleration (Higher frequency): ', num2str(mean(abs(vertAcc2)))])