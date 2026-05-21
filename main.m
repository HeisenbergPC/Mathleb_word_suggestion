%% --- MAIN SCRIPT ---
% This script runs the bigram model or trigram model
% Make sure all function files are in the same directory
% this 
%% === PART 1 and 2: text processing, training and prediction
fprintf("part 1 and part 2: ");
% 1. Load corpus and preprocess
corpus_file = 'corpus.txt';
tokens = text_processing(corpus_file);
 
% 2. Train the bigram model
[transitionProbs, vocab, word2idx] = train_bigram_model(tokens);
bigramVocab = vocab;
bigramWord2idx = word2idx;

 
% 3. Train the trigram model
trigramModel = train_trigram_model(tokens);

% 4. Test prediction using bigram and trigram model
testW1 = 'i';
testW2 = 'am';

bigramResult = prediction_words_bigram(testW2, transitionProbs, vocab, word2idx);
fprintf('Bigram  prediction after "%s":   %s\n', testW2, bigramResult);

trigramResult = prediction_words_trigram(testW1, testW2, trigramModel);
fprintf('Trigram prediction after "%s %s":   %s\n', testW1, testW2, trigramResult);



%% === PART 3: Vector Representation ===
fprintf('\n=== PART 3: Vector Representation ===\n');

% 5. One-hot encoding (by position)
oneHotMatrix = one_hot_encoding(vocab);

% 6. Co-occurrence embeddings (by neighbors)
[coMatrix, coVocab, coWord2idx] = co_occurrence_embeddings(tokens);

% Testing the one-hot and co-occurrence from above
testWord = 'am';
if isKey(coWord2idx, testWord)
    idx = coWord2idx(testWord);

    fprintf('\nOne-hot vector for "%s" (first 5 dims):\n', testWord);
    disp(oneHotMatrix(idx, 1:5));

    fprintf('Co-occurrence vector for "%s" (first 5 dims):\n', testWord);
    disp(coMatrix(idx, 1:5));
end

% 7. use victor similar prediction
fprintf('\n--- 3.2 Vector Similarity Prediction ---\n');

simWord = 'i';
vecNextWord = predict_vector_similar(simWord, coMatrix, coVocab, coWord2idx);
fprintf('Vector prediction after "%s": %s\n', simWord, vecNextWord);

% 8. compare both approach n-gram and vector representation
testWords = {'i', 'am', 'the', 'she', 'not'};
compare_predictions(testWords, coMatrix, coVocab, coWord2idx, ...
    trigramModel, transitionProbs, vocab, word2idx);

%% === PART 4: Model Evaluation ===
fprintf('\n=== PART 4: Model Evaluation ===\n');
EVAL_FILE = 'trained_models.mat';

if isfile(EVAL_FILE)
    fprintf('Loading cached eval models from "%s"... \n',EVAL_FILE);
    load(EVAL_FILE);
    fprintf('Done. Skipping retraining. \n');
else
    fprintf('No cache found.\n');
    % Split corpus
    [trainTokens, testTokens] = split_corpus(tokens);

    % Train on 80% only
    fprintf('Training bigram...\n');
    [trainTransitionProbs, trainVocab, trainWord2idx] = train_bigram_model(trainTokens);

    fprintf('Training trigram...\n');
    trainTrigramModel = train_trigram_model(trainTokens);

    fprintf('Building co-occurrence matrix...\n');
    [trainCoMatrix, trainCoVocab, trainCoWord2idx] = co_occurrence_embeddings(trainTokens);

    % Save everything 
    fprintf('Saving everything "%s"...\n', EVAL_FILE);
    save(EVAL_FILE, '-v7.3', ...
         'trainTokens', 'testTokens', ...
         'trainTransitionProbs', 'trainVocab', 'trainWord2idx', ...
         'trainTrigramModel', ...
         'trainCoMatrix', 'trainCoVocab', 'trainCoWord2idx');
    fprintf('Saved. Next run will load instantly.\n');
     % 4: Evaluate accuracy on TEST SET
    results = evaluate_accuracy(testTokens, ...
                           trainTransitionProbs, trainVocab, trainWord2idx, ...
                           trainTrigramModel, ...
                           trainCoMatrix, trainCoVocab, trainCoWord2idx);
    
    % 5: Measure perplexity
    perplexity = measure_perplexity(testTokens, trainTransitionProbs, ...
                             trainVocab, trainWord2idx);
    
    % 6: Final comparison
    compare_all_models(results, perplexity);

   
end



 
%% === PART 5: Application and Documentation ===
fprintf('\n=== PART 5: Application and Documentation ===\n');
%  the ui

fprintf('\nLaunching Word Prediction UI...\n');
fprintf('(Type a word in the window and click "Predict Next Word")\n');

word_prediction_ui(transitionProbs, bigramVocab, bigramWord2idx, ...
                   trigramModel, ...
                   coMatrix, coVocab, coWord2idx);






