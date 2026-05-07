function nextWord = hybrid_prediction(w1, w2, trigramModel, transitionProbs, vocab, word2idx)
    nextWord = '';
    key = strcat(lower(w1), ' ', lower(w2));

    % --- 1. Try trigram ---
    if isKey(trigramModel, key)
        nextWords = trigramModel(key);
        words = keys(nextWords);
        counts = cell2mat(values(nextWords));
        [~, idx] = max(counts);
        nextWord = words{idx};
        return;
    end

    % --- 2. Fallback to bigram ---
    w2_lower = lower(w2);
    if ~isKey(word2idx, w2_lower)
        fprintf('Fallback word "%s" not in vocabulary.\n', w2_lower);
        return;
    end
    idx1 = word2idx(w2_lower);
    probs = transitionProbs(idx1, :);
    if nnz(probs) == 0
        fprintf('No transitions from "%s".\n', w2_lower);
        return;
    end
    [~, max_idx] = max(probs);
    nextWord = vocab{max_idx};   % ← KEY FIX: use vocab, not keys(word2idx)
end