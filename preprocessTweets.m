function t = preprocessTweets(tweets,searchTerm)
% PREPROCESSTWEETS  Capture text preprocessing steps in a function
% 
% Copyright 2017-2018 The MathWorks, Inc.
% Source https://www.mathworks.com/matlabcentral/fileexchange/68264-classify-sentiment-of-tweets-using-deep-learning

if nargin < 2
    searchTerm = [];
end

% Preprocess tweets
tweets = lower(tweets);
tweets = eraseURLs(tweets);
tweets = removeHashtags(tweets);
tweets = erasePunctuation(tweets);
t = tokenizedDocument(tweets);

% Edit stop words list to take out words that could carry important meaning
% for sentiment of the tweet
newStopWords = stopWords;
notStopWords = ["are", "aren't", "arent", "can", "can't", "cant", ...
    "cannot", "could", "couldn't", "did", "didn't", "didnt", "do", "does",...
    "doesn't", "doesnt", "don't", "dont", "is", "isn't", "isnt", "no", "not",...
    "was", "wasn't", "wasnt", "with", "without", "won't", "would", "wouldn't"];
newStopWords(ismember(newStopWords,notStopWords)) = [];
t = removeWords(t,newStopWords);

% Remove other common words in tweets
t = removeWords(t,{'rt','retweet','amp','http','https',...
    'stock','stocks','inc'});
t = removeShortWords(t,1);

if ~isempty(searchTerm)
    searchTerm = lower(searchTerm);
    termplural = searchTerm + "s";
    t = removeWords(t,...
        {searchTerm,char(termplural)});
end

end

function tweettext = removeHashtags(tweettext)
torep = {'<[^>]+>', ...                     % HTML tags
    '(?:@[\w_]+)', ...                      % @mentions
    '(?:\#+[\w_]+[\w\''_\-]*[\w_]+)', ...   % #hashtags
    '(?:\$+[\w_]+)',...                     % $tickers 
    '\d'};                                  % numeric values
tweettext = strip(regexprep(tweettext,torep,''));
end

