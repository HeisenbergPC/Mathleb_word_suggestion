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
    
    accuracies = [results.bigramAcc, results.trigramAcc, results.vectorAcc];
    labels     = {'Bigram', 'Trigram', 'Vector Similarity'};
    figure('Name', "Model comparison");
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
end 