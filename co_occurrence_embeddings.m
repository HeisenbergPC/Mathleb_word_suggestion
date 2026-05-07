%% --- Co-occurrence Matrix ---
function [coMatrix, vocab, word2idx] = co_occurrence_embeddings(tokens)

    % Create vocabulary
    vocab = unique(tokens);
    vocabSize = length(vocab);

    % Word to index mapping
    word2idx = containers.Map(vocab, 1:vocabSize);

    % Initialize co-occurrence matrix
    coMatrix = zeros(vocabSize, vocabSize);

    % Window size
    windowSize = 1;
    fprintf('Building co-occurrence matrix (window=%d)...\n', windowSize);

    % Loop through tokens
    for i = 1:length(tokens)
        currentWord = tokens{i};
        currentIdx = word2idx(currentWord);

        % Left neighbor (predict before word in the left)
        % first position don't use left, always use right word
        if i > 1
            leftWord = tokens{i-1};
            leftIdx = word2idx(leftWord);

            coMatrix(currentIdx, leftIdx) = coMatrix(currentIdx, leftIdx) + 1;
                
        end

        % Right neighbor (predict next word in the right)
        if i < length(tokens)
            rightWord = tokens{i+1};
            rightIdx = word2idx(rightWord);

            coMatrix(currentIdx, rightIdx) = ...
                coMatrix(currentIdx, rightIdx) + 1;
        end
    end
end