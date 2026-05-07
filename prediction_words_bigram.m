%% --- Predict Next Word ---
function nextWord = prediction_words_bigram(currentWord, transitionProbs, vocab, word2idx)
% Implement a function that predicts the most likely next word
    nextWord = ''; % Default return if word is unknown

% Convert input to lowercase to match the text processing logic
    currentWord = lower(currentWord);

% Check if the word exists in our trained vocabulary
    if ~isKey(word2idx, currentWord)
        fprintf('Word "%s" not found in vocabulary.\n', currentWord);
        return;
    end

% Get the row index of the current word
    w1_idx = word2idx(currentWord);

% Extract transition probabilities for this word
    probs = transitionProbs(w1_idx, :);

    if nnz(probs) == 0
        fprintf('No known next words following "%s" in the corpus.\n', currentWord);
        return;
    end

% Find the index of the highest probability
    [~, max_idx] = max(probs);

% Return the corresponding word from the vocabulary array
    nextWord = vocab{max_idx};
end