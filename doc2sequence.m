function C = doc2sequence(emb,documents)
% DOC2SEQUENCE Convert text to numeric matrices and prepare for LSTM model
%
% Copyright 2017-2018 The MathWorks, Inc.

% Preallocate
n = numel(documents);
C = cell(n,1);

parfor ii = 1:n
    % Convert text to numeric data for each based on word embedding
    words = string(documents(ii));
    idx = ~ismember(emb,words);
    words(idx) = [];
    C{ii} = word2vec(emb,words)';
    
end

end


