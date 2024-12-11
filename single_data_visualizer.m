% Script for visualizing data from a single data file

fileName = '';
%fileName = '';

% Load data from file in to a table
Data = readtable(fileName);

% Extract datacolumns from the table
time = Data{:,1};       % (Unix) time in seconds
accx = Data{:,2};       % Acceleration in phone's local x-axis
accy = Data{:,3};       % Acceleration in phone's local y-axis
accz = Data{:,4};       % Acceleration in phone's local z-axis
lat = Data{:,5};        % Latitude
lon = Data{:,6};        % Longitude
vertAcc = Data{:,7};    % Vertical acceleration

% Normalize time axis so that it starts from 0 seconds
% Also gather information about the sampling frequency of the data
start_time = time(1);
end_time = time(end);
total_time = end_time - start_time;
num_data_points = length(time);
F = num_data_points / total_time;  % Frequency in Hz [1/s]
interpInterval = 1 / F;            % Time interval for interpolating in seconds

% Create a new time axis that is normalized to start from 0
% And that also contains sub-second values
newTime = linspace(0, total_time, num_data_points);

% Calculate total traveled distance
totalDistance = calculate_total_distance(lat, lon);

% Plot the data
figure('Position', [100, 100, 1400, 800]);

%{

% Plot accx with respect to time
subplot(3, 2, 1);
plot(newTime, accx, 'r');
xlabel('Time (s)');
ylabel('AccX (m/s²)');
title('Acceleration (X)');
grid on;

% Plot accy with respect to time
subplot(3, 2, 3);
plot(newTime, accy, 'g');
xlabel('Time (s)');
ylabel('AccY (m/s²)');
title('Acceleration (Y)');
grid on;

% Plot accz with respect to time
subplot(3, 2, 5);
plot(newTime, accz, 'b');
xlabel('Time (s)');
ylabel('AccZ (m/s²)');
title('Acceleration (Z)');
grid on;

%}

% Plot vertical acceleration with respect to time
plot(newTime, vertAcc, 'b');
xlabel('Time (s)');
ylabel('Vertical Acc (m/s²)');
title(sprintf('Vertical acceleration, %.0f Hz', F));
grid on;

disp(['Estimated sampling frequency: ', num2str(F), ' Hz'])
disp(['Total traveled distance: ', num2str(totalDistance), ' meters']);

% Standard deviation easily calculated using built-in functions
disp(['Standard deviation (Horizontal): ', num2str(std(vertAcc))]);

% Also average acceleration (from absolute acceleration values)
disp(['Average acceleration (Horizontal): ', num2str(mean(abs(vertAcc)))])

function total_distance = calculate_total_distance(latitude, longitude)

% Convert latitude and longitude from degrees to radians
lat_radians = deg2rad(latitude);
long_radians = deg2rad(longitude);

% Earth's radius in meters
earthRadius = 6371000;

% Initialize total distance
total_distance = 0;

    % Calculate distances between consecutive points
    for i = 1:(length(latitude) - 1)
         deltaLat = lat_radians(i+1) - lat_radians(i);
         deltaLon = long_radians(i+1) - long_radians(i);

         % Implement the Haversine formula to calculate the distance   
         a = sin(deltaLat/2).^2 + cos(lat_radians(i))*cos(lat_radians(i+1))*sin(deltaLon/2).^2;
         c = 2 * atan2(sqrt(a), sqrt(1-a));
         distance = earthRadius * c;
            
         total_distance = total_distance + distance;
    end
end
