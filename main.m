
%tokens = text_processing("corpus.txt");
%analyze_and_visualize(tokens);




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
  

    % Access the i-th word (assuming vocab is a cell array)
    input_word = 'I';  

    % Predict next word
    predicted_word = predict_most_likely_word(input_word, transitionProbs, vocab, word2idx);

    

    fprintf('["%s" , "%s"].\n', input_word, predicted_word);

 
