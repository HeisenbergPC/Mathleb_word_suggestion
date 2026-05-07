function compare_predictions(testWords, coMatrix, coVocab, coWord2idx, ...
                              trigramModel, transitionProbs, bigramVocab, bigramWord2idx)
% Compares vector similarity prediction vs n-gram prediction (bigram model)

    fprintf('\n========================================\n');
    fprintf('   PREDICTION COMPARISON: Vector vs N-gram\n');
    fprintf('========================================\n');
    fprintf('%-15s %-20s %-20s\n', 'Input Word', 'Vector Similarity', 'N-gram (Bigram)');
    fprintf('%-15s %-20s %-20s\n', '----------', '-----------------', '---------------');


    for i = 1:length(testWords)
        word = lower(testWords{i});

        % --- Vector similarity prediction ---
        vecPrediction = predict_vector_similar(word, coMatrix, coVocab, coWord2idx);

        % --- N-gram prediction (bigram fallback) ---
        ngramPrediction = '';

        %check word if it exist in vocab
        if isKey(bigramWord2idx, word)
            idx = bigramWord2idx(word);
            probs = transitionProbs(idx, :);

            % check there are anu probabilities
            if nnz(probs) > 0
                [~, maxIdx] = max(probs);
                ngramPrediction = bigramVocab{maxIdx};
            end
        end

        % handle missing predictions
        if isempty(vecPrediction),   vecPrediction   = 'N/A'; end
        if isempty(ngramPrediction), ngramPrediction = 'N/A'; end

        fprintf('%-15s %-20s %-20s\n', word, vecPrediction, ngramPrediction);
    end
    fprintf('========================================\n\n');
end