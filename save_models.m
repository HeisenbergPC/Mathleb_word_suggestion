% save models.

function save_models(filename, transitionProbs, bigramVocab, bigramWord2idx, ...
                     trigramModel, coMatrix, coVocab, coWord2idx)
    fprintf('Saving models to "%s"...\n', filename);
    
    % Save using a struct so variable names are preserved correctly
    data.transitionProbs  = transitionProbs;
    data.bigramVocab      = bigramVocab;
    data.bigramWord2idx   = bigramWord2idx;
    data.trigramModel     = trigramModel;
    data.coMatrix         = coMatrix;
    data.coVocab          = coVocab;
    data.coWord2idx       = coWord2idx;
    
    save(filename, '-struct', 'data');
    
    info = dir(filename);
    fprintf('Done. File size: %.2f MB\n', info.bytes / 1e6);
end