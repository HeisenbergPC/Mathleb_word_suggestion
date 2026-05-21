%% --- MAIN SCRIPT ---
% This script runs the bigram model or trigram model
% Make sure all function files are in the same directory
% this 
%% === PART 1 and 2: text processing, training and prediction
fprintf("part 1 and part 2: \n");
% 1. Load corpus and preprocess
corpus_file = 'corpus.txt';
tokens = text_processing(corpus_file);
analyze_and_visualize(tokens);
 
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










