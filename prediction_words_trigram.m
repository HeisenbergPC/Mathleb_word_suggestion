function nextWord = prediction_words_trigram(w1, w2, trigramCounts)

    nextWord = '';

    w1 = lower(w1);
    w2 = lower(w2);

    key = strcat(w1, ' ', w2);

    if ~isKey(trigramCounts, key)
        fprintf('Word pair "%s" not found.\n', key);
        return;
    end

    nextWords = trigramCounts(key);

    words = keys(nextWords);
    counts = cell2mat(values(nextWords));

    [~, idx] = max(counts);

    nextWord = words{idx};
end