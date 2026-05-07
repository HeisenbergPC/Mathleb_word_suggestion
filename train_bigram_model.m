

%% --- Build Bigram Model ---
function [transitionProbs, vocab, word2idx] = train_bigram_model(tokens)
% Create Vocabulary: Find unique words
    vocab = unique(tokens);
    numWords = length(vocab);
% Create a mapping from word to index for fast lookup
    word2idx = containers.Map(vocab, 1:numWords);
% Initialize a sparse matrix for bigram counts to save memory
    bigramCounts = sparse(numWords, numWords);
    unigramCounts = zeros(numWords, 1);
 
% 1. Create a frequency table of word pairs
    for i = 1:(length(tokens) - 1)
        w1 = word2idx(tokens{i});
        w2 = word2idx(tokens{i+1});
        bigramCounts(w1, w2) = bigramCounts(w1, w2) + 1;
        unigramCounts(w1) = unigramCounts(w1) + 1;
    end
 
% Add the last word to the unigram count
    last_w = word2idx(tokens{end});
    unigramCounts(last_w) = unigramCounts(last_w) + 1;
 
% 2. Calculate transition probabilities
% P(w2 | w1) = count(w1, w2) / count(w1)
% We use spdiags to multiply by the inverse of unigram counts efficiently
    invUnigram = 1 ./ unigramCounts;
    invUnigram(isinf(invUnigram)) = 0; % Prevent division by zero
    %D = spdiags(invUnigram, 0, numWords, numWords);
    %transitionProbs = D * bigramCounts;
    % NEW CODE WITH LAPLACE SMOOTHING:
    bigramCounts_smoothed = bigramCounts + 1;  % Add 1 to all cells
    unigramCounts_smoothed = sum(bigramCounts_smoothed, 2);  % Recalculate sums
    invUnigram_smoothed = 1 ./ unigramCounts_smoothed;
    invUnigram_smoothed(isinf(invUnigram_smoothed)) = 0;
    D_smoothed = spdiags(invUnigram_smoothed, 0, numWords, numWords);
    transitionProbs = D_smoothed * bigramCounts_smoothed;
end