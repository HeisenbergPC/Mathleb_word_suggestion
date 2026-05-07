%% --- MAIN SCRIPT ---
% This script runs the bigram language model
% Make sure all function files are in the same directory




 
% 1. Load corpus and preprocess
corpus_file = 'corpus.txt';
tokens = text_processing(corpus_file);
 
% 2. Train the bigram model
[transitionProbs, vocab, word2idx] = train_bigram_model(tokens);

 
% 3. Test the prediction
% predicted_word = predict_most_likely_word(input_word, transitionProbs, vocab, word2idx);
% fprintf('"%s" is pair "%s".\n', input_word, predicted_word);
% Display each element

% Show the total length (same every iteration)


trigramModel = train_trigram_model(tokens);

w1 = 'i';
w2 = 'am';
w3 = hybrid_prediction(w1, w2, trigramModel, transitionProbs, vocab, word2idx);

fprintf('Prediction: %s %s %s\n', w1, w2, w3);
 
