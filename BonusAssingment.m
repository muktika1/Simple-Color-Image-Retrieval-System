%Name : Muktika Manohar
%Email id : mm87150n@pace.edu
%Bonus Assignment

% Load images
elephant1 = imread('/Users/muku/Downloads/Elephant1.jpg');
elephant2 = imread('/Users/muku/Downloads/Elephant2.jpg');
horse1 = imread('/Users/muku/Downloads/Horse1.jpg');
horse2 = imread('/Users/muku/Downloads/Horse2.jpg');

% Compute histograms
hist_elephant1 = Cal256binHSV(elephant1);
hist_elephant2 = Cal256binHSV(elephant2);
hist_horse1 = Cal256binHSV(horse1);
hist_horse2 = Cal256binHSV(horse2);

% Plot histograms
figure(1);
subplot(2, 2, 1);
bar(hist_elephant1);
title('Elephant1 Histogram');

subplot(2, 2, 2);
bar(hist_elephant2);
title('Elephant2 Histogram');

subplot(2, 2, 3);
bar(hist_horse1);
title('Horse1 Histogram');

subplot(2, 2, 4);
bar(hist_horse2);
title('Horse2 Histogram');

% Create a database of histograms and image names
database = {hist_elephant1, hist_elephant2, hist_horse1, hist_horse2};
image_names = {'Elephant1', 'Elephant2', 'Horse1', 'Horse2'};

% Initialize figure for retrieval results
for query_idx = 1:4
    query_hist = database{query_idx};
    
    % Calculate histogram intersections and rank images
    similarity_scores = zeros(1, 4);
    for i = 1:4
        similarity_scores(i) = sum(min(query_hist, database{i})) / min(sum(query_hist), sum(database{i}));
    end
    
    % Sort results
    [sorted_scores, sorted_indices] = sort(similarity_scores, 'descend');
    
    % Plot retrieval results
    figure(query_idx + 1);
    for i = 1:4
        subplot(2, 2, i);
        imshow(imread([image_names{sorted_indices(i)}, '.jpg']));
        title(['Rank: ', num2str(i), ', Score: ', num2str(sorted_scores(i))]);
    end
end

% Function to compute 256-bin HSV color histogram
function hist = Cal256binHSV(image)
    % Convert the image to HSV color space
    hsv_image = rgb2hsv(image);

    % Define the number of bins for each channel
    h_bins = 16;
    s_bins = 4;
    v_bins = 4;

    % Extract the individual channels
    h_channel = hsv_image(:, :, 1);
    s_channel = hsv_image(:, :, 2);
    v_channel = hsv_image(:, :, 3);

    % Calculate histograms for each channel
    hist_h = histcounts(h_channel(:), linspace(0, 1, h_bins+1));
    hist_s = histcounts(s_channel(:), linspace(0, 1, s_bins+1));
    hist_v = histcounts(v_channel(:), linspace(0, 1, v_bins+1));

    % Combine the histograms
    hist = [hist_h, hist_s, hist_v];

    % Normalize the histogram
    hist = hist / sum(hist(:));
end
