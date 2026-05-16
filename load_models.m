%% --- Load Trained Models from Disk ---
%
% Loads all trained model variables from a saved .mat file.
% Use this instead of retraining every time you run the script.
%
% Usage:
%   [transitionProbs, vocab, word2idx, trigramModel, ...
%    coMatrix, coVocab, coWord2idx] = load_models('trained_models.mat')

function [transitionProbs, bigramVocab, bigramWord2idx, ...
          trigramModel, coMatrix, coVocab, coWord2idx] = load_models(filename)

    fprintf('Loading models from "%s"...\n', filename);

    data = load(filename);

    transitionProbs  = data.transitionProbs;
    bigramVocab      = data.bigramVocab;
    bigramWord2idx   = data.bigramWord2idx;
    trigramModel     = data.trigramModel;
    coMatrix         = data.coMatrix;
    coVocab          = data.coVocab;
    coWord2idx       = data.coWord2idx;

    fprintf('Done. All models loaded successfully.\n');
end