%% --- Save Trained Models to Disk ---
%
% PURPOSE:
%   Saves all trained model data into a single .mat file so you do not
%   need to retrain from scratch every time you run the project.
%   Training on a large corpus can take 30-60 seconds; saving lets you
%   load in under 1 second on future runs.
%
% INPUTS:
%   filename        - string, e.g. 'trained_models.mat'
%   transitionProbs - bigram transition probability matrix (sparse)
%   bigramVocab     - cell array of vocabulary words (bigram)
%   bigramWord2idx  - containers.Map: word -> index (bigram)
%   trigramModel    - containers.Map of Maps: "w1 w2" -> {w3: count}
%   coMatrix        - co-occurrence embedding matrix
%   coVocab         - cell array of vocabulary words (co-occurrence)
%   coWord2idx      - containers.Map: word -> index (co-occurrence)
%
% OUTPUT:
%   Saves a .mat file to the current working directory.

function save_models(filename, ...
                     transitionProbs, bigramVocab, bigramWord2idx, ...
                     trigramModel, ...
                     coMatrix, coVocab, coWord2idx)

    fprintf('\n=== Saving Models ===\n');
    fprintf('Destination: %s\n', filename);

    % containers.Map cannot be saved directly in all MATLAB versions.
    % We convert them to struct-compatible formats first.

    % --- Convert bigramWord2idx (Map) to two parallel arrays ---
    bigram_keys   = keys(bigramWord2idx);
    bigram_values = cell2mat(values(bigramWord2idx));

    % --- Convert coWord2idx (Map) to two parallel arrays ---
    co_keys   = keys(coWord2idx);
    co_values = cell2mat(values(coWord2idx));

    % --- Convert trigramModel (nested Map) to a struct ---
    % Outer keys: word pairs like "the cat"
    % Inner keys: candidate next words
    trigramKeys = keys(trigramModel);
    trigramData = struct();
    trigramData.outerKeys = trigramKeys;
    trigramData.innerKeys = {};
    trigramData.innerVals = {};

    for i = 1:length(trigramKeys)
        innerMap = trigramModel(trigramKeys{i});
        trigramData.innerKeys{end+1} = keys(innerMap);
        trigramData.innerVals{end+1} = cell2mat(values(innerMap));
    end

    % --- Save everything ---
    save(filename, ...
         'transitionProbs', ...
         'bigramVocab', ...
         'bigram_keys', 'bigram_values', ...
         'trigramData', ...
         'coMatrix', ...
         'coVocab', ...
         'co_keys', 'co_values');

    fileInfo = dir(filename);
    fprintf('Saved successfully! File size: %.1f KB\n', fileInfo.bytes / 1024);
    fprintf('=====================\n');

end