%% --- Implement text preprocessing functions ---

function tokens = text_processing(corpus_file)
    % Load the raw text
    rawText = fileread(corpus_file);
    
    % Convert to lowercase
    cleanText = lower(rawText);
    
    % Remove punctuation using Regex
    % This replaces any character that IS NOT a letter, number, or space with nothing
    cleanText = regexprep(cleanText, '[^a-z0-9\s]', '');
    
    % Normalize whitespace (Removes double spaces or newlines)
    cleanText = strtrim(regexprep(cleanText, '\s+', ' '));
    
    % Tokenize: Split the string into a cell array of words
    tokens = split(cleanText);

    % --- Extra cleaning step ---
    % Remove tokens that are only numbers or contain digits
    % This clears picture numbers, IDs, and mixed alphanumeric junk
    isBad = cellfun(@(t) ~isempty(regexp(t,'\d','once')), tokens);
    tokens = tokens(~isBad);
    
    % Create Vocabulary: Find unique words
    % This is just a quick way for showing unique words.
    % It's not optimized for furthur processing.
    vocab = unique(tokens);
    % disp(vocab);

end
