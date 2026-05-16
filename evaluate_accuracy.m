%% --- Evaluate Prediction Accuracy of All 3 Models ---
% For each word in the test set, we ask each model:
% "given this word, what is the next word?"
% Then we check if the prediction matches the actual next word.
%
% Inputs:
% testTokens   - the 20% test token array
% transitionProbs, bigramVocab, bigramWord2idx  - from train_bigram_model
% trigramModel                                  - from train_trigram_model
% coMatrix, coVocab, coWord2idx                 - from co_occurrence_embeddings

function results = evaluate_accuracy(testTokens, ...
                                     transitionProbs, bigramVocab, bigramWord2idx, ...
                                     trigramModel, ...
                                     coMatrix, coVocab, coWord2idx)

    fprintf('\n=== Evaluating Prediction Accuracy ===\n');
    
    totalPairs = length(testTokens) - 1;
    
    % Counters for correct predictions
    bigramCorrect  = 0;
    trigramCorrect = 0;
    vectorCorrect  = 0;
    
    % Counters for how many times a model could even attempt a prediction
    bigramAttempts  = 0;
    trigramAttempts = 0;
    vectorAttempts  = 0;
    
    % Pre-compute co-occurrence vector norms once (saves time in the loop)
    coNorms = sqrt(sum(coMatrix .^ 2, 2));
    fprintf('Evaluating %d test pairs...\n', totalPairs);
    
    %% --- Main evaluation loop ---
    for i = 1:totalPairs
        currentWord = testTokens{i};
        actualNext  = testTokens{i+1};
    
        %% --- Bigram prediction ---
        % Given current word, predict next word using transition probabilities
        if isKey(bigramWord2idx, currentWord)
            bigramAttempts = bigramAttempts + 1;
            idx   = bigramWord2idx(currentWord);
            probs = transitionProbs(idx, :);
            if nnz(probs) > 0
                [~, maxIdx]  = max(probs);
                bigramPred   = bigramVocab{maxIdx};
                if strcmp(bigramPred, actualNext)
                    bigramCorrect = bigramCorrect + 1;
                end
            end
        end
    
        %% --- Trigram prediction ---
        % Given previous + current word, predict next word
        if i > 1
            prevWord = testTokens{i-1};
            key      = strcat(prevWord, ' ', currentWord);
            if isKey(trigramModel, key)
                trigramAttempts = trigramAttempts + 1;
                nextWords       = trigramModel(key);
                words           = keys(nextWords);
                counts          = cell2mat(values(nextWords));
                [~, bestIdx]    = max(counts);
                trigramPred     = words{bestIdx};
                if strcmp(trigramPred, actualNext)
                    trigramCorrect = trigramCorrect + 1;
                end
            end
        end
    
        %% --- Vector similarity prediction ---
        % Find the most similar word to current word using cosine similarity
        if isKey(coWord2idx, currentWord)
            wordIdx    = coWord2idx(currentWord);
            wordVector = coMatrix(wordIdx, :);
            dA         = coNorms(wordIdx);
    
            if dA > 0
                vectorAttempts = vectorAttempts + 1;
                similarities   = (coMatrix * wordVector') ./ (coNorms * dA);
                similarities(coNorms == 0) = 0;
                similarities(wordIdx)      = -1;  % exclude the word itself
                [~, bestIdx] = max(similarities);
                vectorPred   = coVocab{bestIdx};
                if strcmp(vectorPred, actualNext)
                    vectorCorrect = vectorCorrect + 1;
                end
            end
        end
    
    end  % end of main loop
    
    %% --- Calculate final accuracy percentages ---
    bigramAcc  = 100 * bigramCorrect  / max(bigramAttempts,  1);
    trigramAcc = 100 * trigramCorrect / max(trigramAttempts, 1);
    vectorAcc  = 100 * vectorCorrect  / max(vectorAttempts,  1);
    
    %% --- Display results table ---
    fprintf('\n%-20s %-12s %-12s %-10s\n', 'Model',   'Correct', 'Attempts', 'Accuracy');
    fprintf('%-20s %-12s %-12s %-10s\n', '-----',    '-------', '--------', '--------');
    fprintf('%-20s %-12d %-12d %.2f%%\n', 'Bigram',  bigramCorrect,  bigramAttempts,  bigramAcc);
    fprintf('%-20s %-12d %-12d %.2f%%\n', 'Trigram', trigramCorrect, trigramAttempts, trigramAcc);
    fprintf('%-20s %-12d %-12d %.2f%%\n', 'Vector',  vectorCorrect,  vectorAttempts,  vectorAcc);
    fprintf('=========================================\n');
    
    %% --- Return results as a struct ---
    results.bigramAcc       = bigramAcc;
    results.trigramAcc      = trigramAcc;
    results.vectorAcc       = vectorAcc;
    results.bigramCorrect   = bigramCorrect;
    results.trigramCorrect  = trigramCorrect;
    results.vectorCorrect   = vectorCorrect;
    results.bigramAttempts  = bigramAttempts;
    results.trigramAttempts = trigramAttempts;
    results.vectorAttempts  = vectorAttempts;

end