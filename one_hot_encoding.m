%% --- One Hot Encoding ---
function [oneHotMatrix, vocab, word2idx] = one_hot_encoding(tokens)

    % Create vocabulary and get unique value
    vocab = unique(tokens);

    % Number of unique words
    vocabSize = length(vocab);

    % Create word-to-index mapping
    word2idx = containers.Map(vocab, 1:vocabSize);

    % Create identity matrix
    % Each row becomes one-hot vector
    oneHotMatrix = eye(vocabSize);

end