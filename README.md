# Mathleb_word_khmer_suggestion

## Files to view step by step:
### part 1
1. look at text_processing.m
2. analyze_and_visualize.m

### part 2
3. train_bigram_model.m
4. train_trigram_model.m (me added this you can delete if u want)
5. prediction_words_bigram.m 
6. prediction_words_trigram.m ( i added this file you can remove it if you want)

### part 3
7. one_hot_encoding.m
8. co-occurrence word embeddings.m
9. predict_vector_similar.m
10. compare_predictions.m

### part 4
11. split_corpus.m
12. evaluate_accuracy.m
13. measure_perplexity.m
14. compare_all_models.m


## Run in main.m

the flow is: 
    - we need a clean text ( in part 1 ) convert it into tokens.
    - train_bigram and trigram. then, test these two prediction.
      in part 2
    - create a vector model: one_hot_encode + co_occurrence.
      then test one_hot + co_occurrence and predict_vector
      then compare_prediction between n-gram vs vector
    - split copus into training and testing (80 + 20): take 80% of tokens
      and 20 % of token. So train on trigram + bigram + vector again (80%)
      and save into trained_models.mat and load (if run for two times and more)
    - part 5: ui for prediction. (not yet done)




             
