%% --- Word Prediction UI (Keyboard Style) ---
%
% Simulates a real mobile keyboard word predictor.
% A polling timer checks every 0.3s if the text changed.
% When text stops changing for 0.6s, 3 word suggestions pop up.
% Click a suggestion to append it to your sentence.
%
% Usage:
%   word_prediction_ui(transitionProbs, bigramVocab, bigramWord2idx, ...
%                      trigramModel, coMatrix, coVocab, coWord2idx)

function word_prediction_ui(transitionProbs, bigramVocab, bigramWord2idx, ...
                             trigramModel, ...
                             coMatrix, coVocab, coWord2idx)

    %% ── Shared state ──────────────────────────────────────────────────────
    lastSeenText   = '';
    lastChangeTime = 0;
    predictionDone = true;

    %% ── Window ────────────────────────────────────────────────────────────
    fig = uifigure('Name', 'Word Prediction', ...
                   'Position', [150 150 540 400], ...
                   'Color',    [0.11 0.11 0.13], ...
                   'Resize',   'off');

    %% ── Title ────────────────────────────────────────────────────────────
    uilabel(fig, ...
        'Text',                'Next Word Prediction', ...
        'Position',            [0 360 540 32], ...
        'FontSize',            18, ...
        'FontWeight',          'bold', ...
        'FontColor',           [0.95 0.95 1.0], ...
        'HorizontalAlignment', 'center', ...
        'BackgroundColor',     [0.11 0.11 0.13]);

    %% ── Text area ────────────────────────────────────────────────────────
    inputBox = uitextarea(fig, ...
        'Position',        [20 195 500 155], ...
        'FontSize',        16, ...
        'FontColor',       [0.95 0.95 1.0], ...
        'BackgroundColor', [0.18 0.18 0.22], ...
        'Editable',        true);

    %% ── Suggestion chips (3 word buttons, no labels) ─────────────────────
    chipW   = 155;
    chipGap = 10;
    chipY   = 148;
    totalW  = 3*chipW + 2*chipGap;
    startX  = (540 - totalW) / 2;

    chipBtns = gobjects(1, 3);
    for k = 1:3
        xPos = startX + (k-1)*(chipW + chipGap);
        chipBtns(k) = uibutton(fig, 'push', ...
            'Text',            '', ...
            'Position',        [xPos chipY chipW 36], ...
            'FontSize',        14, ...
            'FontWeight',      'bold', ...
            'FontColor',       [0.95 0.95 1.0], ...
            'BackgroundColor', [0.22 0.22 0.28], ...
            'Visible',         'off', ...
            'ButtonPushedFcn', @(b,~) appendWord(b.Text));
    end

    %% ── Divider line above chips ─────────────────────────────────────────
    % Simulated with a thin label acting as a separator
    uilabel(fig, ...
        'Text',            '', ...
        'Position',        [20 143 500 2], ...
        'BackgroundColor', [0.28 0.28 0.35]);

    %% ── Status label ─────────────────────────────────────────────────────
    statusLbl = uilabel(fig, ...
        'Text',                'Start typing...', ...
        'Position',            [0 110 540 24], ...
        'FontSize',            10, ...
        'FontColor',           [0.4 0.4 0.5], ...
        'HorizontalAlignment', 'center', ...
        'BackgroundColor',     [0.11 0.11 0.13]);

    %% ── Clear button ─────────────────────────────────────────────────────
    uibutton(fig, 'push', ...
        'Text',            'Clear', ...
        'Position',        [20 60 80 30], ...
        'FontSize',        11, ...
        'FontColor',       [1 1 1], ...
        'BackgroundColor', [0.35 0.15 0.15], ...
        'ButtonPushedFcn', @(~,~) clearAll());

    %% ── Typing indicator dot ─────────────────────────────────────────────
    typingDot = uilabel(fig, ...
        'Text',            '●', ...
        'Position',        [118 60 20 30], ...
        'FontSize',        14, ...
        'FontColor',       [0.25 0.25 0.3], ...
        'BackgroundColor', [0.11 0.11 0.13]);

    %% ── Polling timer ────────────────────────────────────────────────────
    pollTimer = timer( ...
        'ExecutionMode', 'fixedRate', ...
        'Period',        0.3, ...
        'TimerFcn',      @(~,~) pollText());

    fig.CloseRequestFcn = @(~,~) cleanupAndClose();
    start(pollTimer);

    %% ════════════════════════════════════════════════════════════════════
    %  POLL — runs every 0.3s
    %% ════════════════════════════════════════════════════════════════════
    function pollText()
        if ~isvalid(fig), return; end

        currentText = strtrim(strjoin(inputBox.Value, ' '));

        if ~strcmp(currentText, lastSeenText)
            lastSeenText   = currentText;
            lastChangeTime = tic;
            predictionDone = false;

            typingDot.FontColor = [0.3 0.75 0.45];
            hideChips();

        elseif ~predictionDone && lastChangeTime ~= 0
            if toc(lastChangeTime) >= 0.6
                predictionDone      = true;
                typingDot.FontColor = [0.25 0.25 0.3];
                runPrediction(currentText);
            end
        end
    end

    %% ════════════════════════════════════════════════════════════════════
    %  PREDICTION
    %% ════════════════════════════════════════════════════════════════════
    function runPrediction(currentText)
        raw   = lower(currentText);
        words = strsplit(raw);
        words = words(~cellfun(@isempty, words));

        if isempty(words)
            hideChips();
            statusLbl.Text = 'Start typing...';
            return;
        end

        if length(words) >= 2
            w1 = words{end-1};
            w2 = words{end};
        else
            w1 = '';
            w2 = words{end};
        end

        % Get one prediction from each model
        bPred = getBigramPred(w2);
        tPred = getTrigramPred(w1, w2);
        vPred = getVectorPred(w2);

        % Deduplicate — show unique words only, fill blanks with '—'
        allPreds = {bPred, tPred, vPred};
        seen     = {};
        final    = {'', '', ''};
        slot     = 1;

        for j = 1:3
            w = allPreds{j};
            if ~isempty(w) && ~ismember(w, seen)
                final{slot} = w;
                seen{end+1} = w; %#ok<AGROW>
                slot = slot + 1;
                if slot > 3, break; end
            end
        end

        % Show chips
        anyShown = false;
        for j = 1:3
            if ~isempty(final{j})
                chipBtns(j).Text    = final{j};
                chipBtns(j).Visible = 'on';
                anyShown = true;
            else
                chipBtns(j).Visible = 'off';
            end
        end

        if anyShown
            statusLbl.Text      = sprintf('Suggestions for "%s"', w2);
            statusLbl.FontColor = [0.35 0.7 0.45];
        else
            statusLbl.Text      = sprintf('No predictions found for "%s"', w2);
            statusLbl.FontColor = [0.5 0.4 0.4];
        end
    end

    %% ════════════════════════════════════════════════════════════════════
    %  APPEND WORD
    %% ════════════════════════════════════════════════════════════════════
    function appendWord(word)
        if isempty(word), return; end

        current = strtrim(strjoin(inputBox.Value, ' '));
        if isempty(current)
            newText = word;
        else
            newText = [current, ' ', word];
        end

        inputBox.Value = {newText};
        lastSeenText   = newText;
        lastChangeTime = tic;
        predictionDone = false;

        % Predict immediately after tap
        predictionDone = true;
        runPrediction(newText);
    end

    %% ════════════════════════════════════════════════════════════════════
    %  HELPERS
    %% ════════════════════════════════════════════════════════════════════
    function hideChips()
        for j = 1:3
            chipBtns(j).Visible = 'off';
        end
    end

    function clearAll()
        inputBox.Value      = {''};
        lastSeenText        = '';
        lastChangeTime      = 0;
        predictionDone      = true;
        typingDot.FontColor = [0.25 0.25 0.3];
        statusLbl.Text      = 'Start typing...';
        statusLbl.FontColor = [0.4 0.4 0.5];
        hideChips();
    end

    function cleanupAndClose()
        if strcmp(pollTimer.Running, 'on')
            stop(pollTimer);
        end
        delete(pollTimer);
        delete(fig);
    end

    %% ════════════════════════════════════════════════════════════════════
    %  MODEL HELPERS
    %% ════════════════════════════════════════════════════════════════════
    function nw = getBigramPred(word)
        nw = '';
        if isKey(bigramWord2idx, word)
            idx   = bigramWord2idx(word);
            probs = transitionProbs(idx, :);
            if nnz(probs) > 0
                [~, mi] = max(probs);
                nw = bigramVocab{mi};
            end
        end
    end

    function nw = getTrigramPred(w1, w2)
        nw = '';
        if isempty(w1), return; end
        key = strcat(w1, ' ', w2);
        if isKey(trigramModel, key)
            inner     = trigramModel(key);
            wds       = keys(inner);
            cnts      = cell2mat(values(inner));
            [~, best] = max(cnts);
            nw        = wds{best};
        end
    end

    function nw = getVectorPred(word)
        nw = predict_vector_similar(word, coMatrix, coVocab, coWord2idx);
    end

end