%% --- Measure Perplexity of the Bigram Model ---
%
% Perplexity tells you how "surprised" or "confused" a model is
% when it reads the test data. Lower = better.
%
% Formula: PP = exp( -1/N * sum(log P(w_i | w_{i-1})) )
%
% A perplexity of 100 means the model is as uncertain as if
% it had to choose randomly among 100 equally likely words.
%
% Inputs:
%   testTokens                              - 20% test tokens
%   transitionProbs, vocab, word2idx        - from train_bigram_model

function perplexity = measure_perplexity(testTokens, transitionProbs, vocab, word2idx)

    fprintf('\n=== Measuring Bigram Perplexity ===\n');

    N      = 0;       % count of valid bigram pairs evaluated
    logSum = 0;       % running sum of log probabilities

    % Small floor value to avoid log(0) for unseen pairs
    % Even with Laplace smoothing some pairs may be near-zero
    epsilon = 1e-10;

    for i = 1:(length(testTokens) - 1)

        w1 = testTokens{i};
        w2 = testTokens{i+1};

        % Only evaluate if both words are in the trained vocabulary
        if isKey(word2idx, w1) && isKey(word2idx, w2)
            idx1 = word2idx(w1);
            idx2 = word2idx(w2);

            % Get P(w2 | w1) from the transition matrix
            p = transitionProbs(idx1, idx2);

            % Add to log sum (clamp to epsilon to avoid -Inf)
            logSum = logSum + log(max(p, epsilon));
            N = N + 1;
        end
    end

    if N == 0
        fprintf('Warning: No valid bigram pairs found in test set.\n');
        perplexity = Inf;
        return;
    end

    % Perplexity formula
    perplexity = exp(-logSum / N);

    fprintf('Valid bigram pairs evaluated : %d\n', N);
    fprintf('Bigram Perplexity            : %.2f\n', perplexity);
    fprintf('\nInterpretation:\n');
    fprintf('  Lower perplexity = model is more confident = better fit.\n');
    fprintf('  Perplexity of %.0f means the model is as uncertain\n', round(perplexity));
    fprintf('  as randomly picking from ~%.0f equally likely words.\n', round(perplexity));
    fprintf('===================================\n');

end