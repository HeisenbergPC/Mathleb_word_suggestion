% --- Compare All Model Approaches ---
% Display a final summary table and bar chart of all 3 models:
%   - Bigram (n-gram, Part 2)
%   - Trigram(n-gram, Part 2)
%   - Vector similarity / co-occurrence (Part 3)
%
% Also prints strengths and weaknesses of each approach
% 
% Inputs:
% results       -struct returned by evaluate_accuracy()
% perplexity    -value returned by measure_perplexity()

function compare_all_models(results, perplexity)

    fprintf('\n');
    fprintf('╔══════════════════════════════════════════════════════╗\n');
    fprintf('║           FINAL MODEL COMPARISON — PART 4           ║\n');
    fprintf('╠══════════════════════════════════════════════════════╣\n');
    fprintf('║ %-18s %-12s %-18s ║\n', 'Model', 'Accuracy', 'Notes');
    fprintf('╠══════════════════════════════════════════════════════╣\n');
    fprintf('║ %-18s %-12s %-18s ║\n', 'Bigram',  ...
            sprintf('%.2f%%', results.bigramAcc),  'P(w2|w1)');
    fprintf('║ %-18s %-12s %-18s ║\n', 'Trigram', ...
            sprintf('%.2f%%', results.trigramAcc), 'P(w3|w1,w2)');
    fprintf('║ %-18s %-12s %-18s ║\n', 'Vector sim.', ...
            sprintf('%.2f%%', results.vectorAcc),  'cosine similarity');
    fprintf('╠══════════════════════════════════════════════════════╣\n');
    fprintf('║ Bigram Perplexity : %-32.2f║\n', perplexity);
    fprintf('╚══════════════════════════════════════════════════════╝\n');

    bar(accuracies, 0.5, 'FaceColor', [0.2 0.5 0.8]);
    set(gca, 'XTickLabel', labels);
    title('Prediction Accuracy by Model (%)');
    ylabel('Accuracy (%)');
    xlabel('Model');
    ylim([0, max(accuracies) * 1.3 + 1]);
    grid on;
 
    % Add value labels on top of each bar
    for k = 1:length(accuracies)
        text(k, accuracies(k) + 0.3, sprintf('%.2f%%', accuracies(k)), ...
             'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold');
    end
 
    %% --- Strengths and Weaknesses ---
    fprintf('\n=== Strengths and Weaknesses ===\n\n');
 
    fprintf('1. BIGRAM MODEL\n');
    fprintf('   Strengths:\n');
    fprintf('   + Simple and fast to train\n');
    fprintf('   + Works well for common word pairs (e.g. "the cat")\n');
    fprintf('   + Laplace smoothing handles unseen words gracefully\n');
    fprintf('   Weaknesses:\n');
    fprintf('   - Only looks at 1 previous word — very short memory\n');
    fprintf('   - Cannot capture long-range dependencies\n');
    fprintf('   - Predicts the same word for a given input regardless of context\n\n');
 
    fprintf('2. TRIGRAM MODEL\n');
    fprintf('   Strengths:\n');
    fprintf('   + Uses 2 previous words — better context than bigram\n');
    fprintf('   + More accurate when the word pair is seen in training\n');
    fprintf('   Weaknesses:\n');
    fprintf('   - Data sparsity: many word pairs never appear in training\n');
    fprintf('   - Falls back to nothing when the pair is unseen (no smoothing here)\n');
    fprintf('   - Memory usage grows much faster than bigram\n\n');
 
    fprintf('3. VECTOR SIMILARITY (Co-occurrence Embeddings)\n');
    fprintf('   Strengths:\n');
    fprintf('   + Captures semantic similarity (similar words cluster together)\n');
    fprintf('   + Works even for less frequent words\n');
    fprintf('   + Can generalise across synonyms or related words\n');
    fprintf('   Weaknesses:\n');
    fprintf('   - Window=1 is very small — misses broader context\n');
    fprintf('   - Cosine similarity finds the most "similar" word, not the most "likely next" word\n');
    fprintf('   - Computationally slow for large vocabularies (loops through all words)\n');
    fprintf('   - No probability model — cannot compute perplexity\n\n');
 
    fprintf('================================\n');
    fprintf('Conclusion: Trigram > Bigram > Vector for raw next-word accuracy\n');
    fprintf('on this corpus. Vector embeddings are better suited for\n');
    fprintf('semantic tasks (word similarity, analogy) than direct prediction.\n');
    fprintf('================================\n\n');
 
end 