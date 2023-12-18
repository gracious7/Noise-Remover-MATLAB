
% Prompt user to record noisy message signal
fs = 44100;  % sampling rate
duration = 5;  % recording duration in seconds
fprintf('Recording %d seconds of noisy message signal...\n', duration);
recorder = audiorecorder(fs, 16, 1);
recordblocking(recorder, duration);
y = getaudiodata(recorder);

% Rest of the code goes here...


% Define filter coefficients
mu = 0.1;  % step size
M = 32;    % filter length
h = zeros(M, 1);

% Generate clean message signal
t = (0:length(y)-1)/fs;
d = sin(2*pi*1000*t);

% Initialize variables
N = length(y);
x_hat = zeros(N, 1);
e = zeros(N, 1);

% Active noise cancellation algorithm
for n = M:N
    % Extract current frame
    x = y(n:-1:n-M+1);
    
    % Filter the input signal
    y_hat = h'*x;
    
    % Compute error signal
    e(n) = d(n) - y_hat;
    
    % Update filter coefficients
    h = h + mu*e(n)*x;
    
    % Estimate clean signal
    x_hat(n) = y(n) - y_hat;
end

% Save the clean audio signal to a file
filename = 'C:\Users\princ\Desktop\DESKTOPP\matlab-works\clean_signal.wav';
audiowrite(filename, x_hat, fs);

% Plot the results
subplot(2,1,1);
plot(t, d, 'b', t, y, 'r');
legend('Original Signal', 'Noisy Signal');
xlabel('Time (s)');
ylabel('Amplitude');
title('Original and Noisy Signals');

subplot(2,1,2);
plot(t, x_hat, 'g');
legend('Clean Signal');
xlabel('Time (s)');
ylabel('Amplitude');
title('Estimated Clean Signal');
