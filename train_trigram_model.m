function [trigramCounts, vocab, word2idx] = train_trigram_model(tokens)

    % Create vocabulary
    vocab = unique(tokens);
    numWords = length(vocab);

    % Word → index map
    word2idx = containers.Map(vocab, 1:numWords);

    % 3D sparse-like structure using containers.Map
    trigramCounts = containers.Map();

    % Build trigram frequencies
    for i = 1:(length(tokens) - 2)

        w1 = tokens{i};
        w2 = tokens{i+1};
        w3 = tokens{i+2};

        key = strcat(w1, ' ', w2);

        if isKey(trigramCounts, key)
            nextWords = trigramCounts(key);
        else
            nextWords = containers.Map();
        end

        if isKey(nextWords, w3)
            nextWords(w3) = nextWords(w3) + 1;
        else
            nextWords(w3) = 1;
        end

        trigramCounts(key) = nextWords;
    end
end