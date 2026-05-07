% Predicts next word by finding which word's vector is most similar
function nextWord = predict_vector_similar(currentWord, coMatrix, vocab, word2idx)

    % variable contain empty string
    nextWord = '';

    % convert to lower case
    currentWord = lower(currentWord);

    % check word exist: currentword -> index
    if ~isKey(word2idx, currentWord)
        fprintf('Word "%s" not found in vocabulary.\n', currentWord);
        return;
    end

    % Get the current word's vector by using coMatrix 
    wordIdx = word2idx(currentWord);
    wordVector = coMatrix(wordIdx, :);

    % check vector has data (wordVector use coMatrix this should have data)
    if sum(wordVector) == 0
        fprintf('No co-occurrence data for "%s".\n', currentWord);
        return;
    end

    % Calculate cosine similarity between current word and all other words
    numWords = length(vocab);
    similarities = zeros(1, numWords);

    for i = 1:numWords
        otherVector = coMatrix(i, :);

        dotProduct = dot(wordVector, otherVector);
        normA = norm(wordVector);
        normB = norm(otherVector);

        if normA > 0 && normB > 0
            % similarity = dot(A, B) / (norm(A) * norm(B))
            similarities(i) = dotProduct / (normA * normB);
        end
    end

    % Don't predict the word itself
    similarities(wordIdx) = -1;

    % Pick the most similar word
    [~, bestIdx] = max(similarities);
    nextWord = vocab{bestIdx};
end