% --- Split Corpus into Training and Testing Sets ---
% Splits a token array into trainTokens (80%) and testTokens (20%)
% Use a fixed random seed so results are reproducible every run

function [trainTokens, testTokens] = split_corpus(tokens)

% Fix the random seed so the split is the same every time you run
rng(42);

totalTokens = length(tokens);

% Shuffles the indices randomly
shuffledIdx = randperm(totalTokens);

% Calculate the cutoff point (80% train, 20% test)
splitPoint = floor(0.8*totalTokens);

% Split the total indices into twp groups
trainIdx = shuffledIdx(1 : splitPoint);
testIdx = shuffledIdx(splitPoint+1 : end);

% Sort indices so the word order is preserved within each split
trainIdx = sort(trainIdx);
testIdx = sort(testIdx);

% Use the indices to pull the actual tokens
trainTokens = tokens(trainIdx);
testTokens = tokens(testIdx);

% Print a summary
fprintf('\n=== Corpus Split ===\n');
fprintf('Total tokens : %d\n', totalTokens);
fprintf('Train tokens : %d (%.0f%%)\n', length(trainTokens), 100*length(trainTokens)/totalTokens);
fprintf('Test tokens  : %d (%0.f%%)\n', length(testTokens), 100*length(testTokens)/totalTokens);