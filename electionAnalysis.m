% I ran:  > save finalStruct tweetStruct
% Don't run this script just run:  > load finalStruct.mat tweetStruct

disp("Loading GloVe word vectors");
fname = "glove.twitter.27B."+100+"d"; 
c = load(fname + '.mat');
wordEmbedding = c.emb;

%{
disp("Dim: ");
disp(wordEmbedding.Dimension());
disp("size of vocab in wordembedding  should be: 1     1193514 ");
disp(size(wordEmbedding.Vocabulary));
%}
disp("Loading pretrained network");
load LSTMModel.mat net;
disp(net.Layers);


%File as in the python project dir move it after data collection
candidatesFile = "/Users/mjscheid/PycharmProjects/twitter_1/Candidates/Candidates.txt";
%canFile = "/Users/mjscheid/Desktop/590_Project/datasets/Candidates.txt";
candidatesData = readtable(candidatesFile,'TextType','string','Delimiter',',','ReadVariableNames',1);
disp("candidates");
disp(candidatesData(:,:));
disp(candidatesData(1,:).screen_name);

canSize = size(candidatesData(:,1));
tweetDir = '/Users/mjscheid/PycharmProjects/twitter_1/rawTwitterData/';


%sentTable = (candidatesData(:,:).screen_name);
%sentTable.postive = -1;
%sentTable.negative = -1;
%sentTable.neutral = -1;
%temp = cell2table(cell(0,3));
%sentTable.postive = temp.Var1;
%sentTable.negative = temp.Var1;
%sentTable.neutral = temp.Var1;
%disp(sentTable(:,:));


candidatesData(:,10) = {0};
candidatesData(:,11) = {0};
candidatesData(:,12) = {0};
candidatesData.Properties.VariableNames{'Var10'} = 'negative';
candidatesData.Properties.VariableNames{'Var11'} = 'neutral';
candidatesData.Properties.VariableNames{'Var12'} = 'postive';

disp(candidatesData);


%tweetTable  = cell2table(cell(0,9), 'VariableNames', candidatesData(:,:).screen_name);
%candidatesData(:,:).screen_name;
%nameArray = candidatesData(:,:).screen_name;
%disp(nameArray);

% 1. Loop to get each canidate's screen_name from the table built from candidates.txt
% 2. Build a struct to hold all the tweets from each
%     candidate---tweetStruct.(screenName) -> table of tweets from that candidates
for i=1:canSize(1)
    % Set currentScreenName. It will be used to access the correct tweet
    % table
    currentScreenName = candidatesData(i,:).screen_name;
    disp(strcat("Current candidate's screen_name:", currentScreenName));
    
    % Open the file contained the tweets
    tweetFile = tweetDir+ strcat(currentScreenName,".txt");
    
    
   
    % Build the current table of tweets and insert it into the struct
    % Example of how to access the first tweet of each canditate
    % tweetStruct.(currentScreenName).tweet(1)
    tweetStruct.(currentScreenName) = readtable(tweetFile,'TextType','string','ReadVariableNames',0);
    tweetStruct.(currentScreenName).Properties.VariableNames{'Var1'}='tweet';
    
    % Perform the same prepocessing that was used on the training data
    tweetStruct.(currentScreenName).tokenizedTweets = preprocessTweets(tweetStruct.(currentScreenName).tweet);
    [~, idx] = removeEmptyDocuments(tweetStruct.(currentScreenName).tokenizedTweets);
    tweetStruct.(currentScreenName)(idx,:) = [];
    tweetStruct.(currentScreenName).wordVec = prepData(wordEmbedding,tweetStruct.(currentScreenName).tokenizedTweets);
    
    % display the first tweet, tokenized tweet, and wordvec rep of the
    % tweet
    disp(strcat("Tweet: ",tweetStruct.(currentScreenName).tweet(1)));
    disp(tweetStruct.(currentScreenName).tokenizedTweets(1));
    %disp("Word vector rep:");
    %disp(tweetStruct.(currentScreenName).wordVec(1));
    %wv1 = tweetStruct.(currentScreenName).wordVec(1);
    %partialRow = wv1{1,1}(101:105);
    %disp("First 5 values from of the GloVe representation of the second token");
    %disp(string(partialRow));
    
    
    % 
    [predictedOutput,~] = classify(net,tweetStruct.(currentScreenName).wordVec);
    tweetStruct.(currentScreenName).output = predictedOutput;
    disp(strcat("Predicted sentiment: ", string(tweetStruct.(currentScreenName).output(1))));
    fprintf("\n\n")
    
    %disp("output size: predictedOutput");
    %disp(size(predictedOutput));
    %disp(summary(predictedOutput));
    
    
    %summary(o)
    %negative      5 
    %neutral       8 
    %positive      7 
    %B = countcats(o);
    sentCounts = countcats(tweetStruct.(currentScreenName).output);
    %negativeCount = sentCounts(1);
    %neutralCount = sentCounts(2);
    %positiveCount = sentCounts(3);
    
    candidatesData(i,:).negative = candidatesData(i,:).negative + sentCounts(1);
    candidatesData(i,:).neutral = candidatesData(i,:).neutral + sentCounts(2);
    candidatesData(i,:).postive = candidatesData(i,:).postive + sentCounts(3);
    
    
    
    
end

disp(candidatesData)

%disp(tweetTable);
%disp(summary(tweetTable))
disp("tweet struct");
disp(tweetStruct);




return

%
%dataTesting.tokenizedTweets = preprocessTweets(dataTesting.tweet);

%
%[~, idx] = removeEmptyDocuments(dataTesting.tokenizedTweets);
%ataTesting(idx,:) = [];
%dataTesting.wordVec = prepData(wordEmbedding,dataTesting.tokenizedTweets);


% Get the predicted values of the tweets
[predictedOutput,~] = classify(net,dataTesting.wordVec);

disp("output size: predictedOutput");
disp(size(predictedOutput));
disp(summary(predictedOutput));


%disp("output size: dataTesting.rating");
%disp(size(dataTesting.rating));
%accuracy = sum(predictedOutput == dataTesting.rating)/numel(predictedOutput);
%disp("accuracy");
%disp(accuracy);



disp("end of electionAnalysis.m");

% The next three Helper functions are by 
% Source Heather Gorr
% https://www.mathworks.com/matlabcentral/fileexchange/68264-classify-sentiment-of-tweets-using-deep-learning
function dataReadyForLSTM = prepData(emb,documents)
% Prep the data for the LSTM network

    % Transform tweets for model
    dataReadyForLSTM = doc2sequence(emb,documents);
        
    % Get the max length and left-pad all sequences with zeros
    sizes = cellfun(@(x) size(x,2),dataReadyForLSTM);
    maxLength = max(sizes);
    parfor i = 1:numel(dataReadyForLSTM)
        dataReadyForLSTM{i} = leftPad(dataReadyForLSTM{i},maxLength);
    end
end

% Source see link above by Heather Gorr
function MPadded = leftPad(M,N)
% Add padding to left
    [dimension,sequenceLength] = size(M);
    paddingLength = N - sequenceLength;
    MPadded = [zeros(dimension,paddingLength) M];
end