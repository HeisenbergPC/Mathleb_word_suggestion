%% --- Load Trained Models from Disk ---
%
% PURPOSE:
%   Loads the .mat file saved by save_models.m and reconstructs
%   all containers.Map objects so the models are ready to use
%   without retraining.
%
% INPUT:
%   filename - string, e.g. 'trained_models.mat'
%
% OUTPUTS:
%   transitionProbs - bigram transition probability matrix
%   bigramVocab     - bigram vocabulary cell array
%   bigramWord2idx  - reconstructed containers.Map (word -> index)
%   trigramModel    - reconstructed nested containers.Map
%   coMatrix        - co-occurrence embedding matrix
%   coVocab         - co-occurrence vocabulary cell array
%   coWord2idx      - reconstructed containers.Map (word -> index)

function [transitionProbs, bigramVocab, bigramWord2idx, ...
          trigramModel, ...
          coMatrix, coVocab, coWord2idx] = load_models(filename)

    fprintf('\n=== Loading Models ===\n');

    % Check file exists before trying to load
    if ~isfile(filename)
        error('Model file "%s" not found.\nRun save_models() first.', filename);
    end

    % Load raw data from file
    data = load(filename);
    fprintf('File loaded: %s\n', filename);

    % --- Restore basic arrays ---
    transitionProbs = data.transitionProbs;
    bigramVocab     = data.bigramVocab;
    coMatrix        = data.coMatrix;
    coVocab         = data.coVocab;

    % --- Rebuild bigramWord2idx Map ---
    bigramWord2idx = containers.Map(data.bigram_keys, data.bigram_values);

    % --- Rebuild coWord2idx Map ---
    coWord2idx = containers.Map(data.co_keys, data.co_values);

    % --- Rebuild trigramModel (nested Map) ---
    trigramModel = containers.Map();
    td = data.trigramData;

    for i = 1:length(td.outerKeys)
        outerKey = td.outerKeys{i};
        innerKeys = td.innerKeys{i};
        innerVals = td.innerVals{i};

        innerMap = containers.Map(innerKeys, innerVals);
        trigramModel(outerKey) = innerMap;
    end

    fprintf('Models restored successfully!\n');
    fprintf('  Bigram vocab size  : %d\n', length(bigramVocab));
    fprintf('  Co-occur vocab size: %d\n', length(coVocab));
    fprintf('  Trigram pairs      : %d\n', length(keys(trigramModel)));
    fprintf('======================\n');

end