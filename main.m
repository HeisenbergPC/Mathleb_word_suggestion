%% --- MAIN SCRIPT ---
% This script runs the bigram model or trigram model
% Make sure all function files are in the same directory

%% === PART 1 and 2: text processing, training and prediction
fprintf("part 1 and part 2: ");
% 1. Load corpus and preprocess
corpus_file = 'corpus.txt';
tokens = text_processing(corpus_file);
 
% 2. Train the bigram model
[transitionProbs, vocab, word2idx] = train_bigram_model(tokens);

 
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

% 5. One-hot encoding (uses bigram vocab)
oneHotMatrix = one_hot_encoding(vocab);

% 6. Co-occurrence embeddings (builds own vocab)
[coMatrix, coVocab, coWord2idx] = co_occurrence_embeddings(tokens);

% Testing the one-hot and co-occurrence (you can delete srach jit)
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

% 8. compare both approach n-gram(bigram) and victor_representation
testWords = {'i', 'am', 'the', 'she', 'not'};
compare_predictions(testWords, coMatrix, coVocab, coWord2idx, ...
                    trigramModel, transitionProbs, vocab, word2idx);


 
