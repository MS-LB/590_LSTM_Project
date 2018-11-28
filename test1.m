% Test File 

% The data is a CSV with emoticons removed. Data file format has 6 fields:
% 0 - the polarity of the tweet (0 = negative, 2 = neutral, 4 = positive)
% 1 - the id of the tweet (2087)
% 2 - the date of the tweet (Sat May 16 23:58:44 UTC 2009)
% 3 - the query (lyx). If there is no query, then this value is NO_QUERY.
% 4 - the user that tweeted (robotickilldozr)
% 5 - the text of the tweet (Lyx is cool)


% Load the data Semeval 2017

% Define the directory
trainingDir = "/Users/mjscheid/Desktop/590_Project/datasets/SemevalData_Part/Training/";
testingDir = "/Users/mjscheid/Desktop/590_Project/datasets/SemevalData_Part/Testing/";
%trainingDir = "/Users/mjscheid/Desktop/590_Project/datasets/SemevalData_Full/Training/";
%testingDir = "/Users/mjscheid/Desktop/590_Project/datasets/SemevalData_Full/Testing/";

% Define the file names
trainingDataInputFileName = "SemEval2017-task4-dev.subtask-A.english.INPUT.txt";
trainingDataOutputFileName = "twitter-2016test-A-English.txt";
testingDataInputFileName = "SemEval2017-task4-test.subtask-A.english.txt";
testingDataOutputFileName = "SemEval2017_task4_subtaskA_test_english_gold.txt";

% Code to load the data Sent140 instead
%{
%dataDir = "/Users/mjscheid/Desktop/590_Project/Sent140/";
%dataFileName = "dataCoupleLines";
%dataFile = dataDir + dataFileName;
%data = readtable(dataFile,'TextType','string', 'Delimiter',',');
%}

% Define the full file path
trainingInputFile = trainingDir + trainingDataInputFileName;
trainingOutputFile = trainingDir + trainingDataOutputFileName;
testingInputFile = testingDir + testingDataInputFileName;
testingOutputFile = testingDir + testingDataOutputFileName;

% Build a table from the data from the text file
trainingInput = readtable(trainingInputFile,'TextType','string');
trainingOutput = readtable(trainingOutputFile,'TextType','string');
%dataTesting = readtable(testingFile,'TextType','string');
%dataTesting = readtable(testingFile,'TextType','string');
testingInput = readtable(testingInputFile,'TextType','string');
testingOutput = readtable(testingOutputFile,'TextType','string');

disp("testingInput");
disp(size(testingInput));
disp(testingInput(1:5,:));
disp("testingOutput");
disp(size(testingOutput));
disp(testingOutput(1:5,:));
dataTesting = testingInput;
dataTesting.Var2 = testingOutput.Var2;
disp("dataTesting");
disp(dataTesting(1:5,:));


% For some reason the training output table has a column of blank strings
% This line removes that empty column in trainingOutput
trainingOutput.Var3 = [];

% Add variable names to the tables
defult_vat_names = ["Var1","Var2","Var3"];
new_var_names = ["id","rating","tweet"];
for i = 1:3
    trainingInput.Properties.VariableNames{char(defult_vat_names(1,i))} = char(new_var_names(1,i));
    dataTesting.Properties.VariableNames{char(defult_vat_names(1,i))} = char(new_var_names(1,i));
    if i < 3
       trainingOutput.Properties.VariableNames{char(defult_vat_names(1,i))} = char(new_var_names(1,i));
       
       %testingOutput.Properties.VariableNames{char(defult_vat_names(1,i))} = char(new_var_names(1,i));
    end
end


%File as in the python project dir move it after data collection
canFile = "/Users/mjscheid/PycharmProjects/twitter_1/Candidates/Candidates.txt";
%canFile = "/Users/mjscheid/Desktop/590_Project/datasets/Candidates.txt";
canData = readtable(canFile,'TextType','string','Delimiter',',','ReadVariableNames',1);

% Print candidates table and how to access a cell 
%{
disp( strcat("candidates from ",canFile) );
disp(canData);
disp(canData.Properties);
% How to access a cell
party_2a = canData.party(2);
%}


% Checking: print out the data
% summary(data);
%{
disp("trainingInput")
disp(trainingInput(1:5,:));
disp("trainingOutput")
disp(trainingOutput(1:5,:));
disp("testingInput")
disp(testingInput(1:5,:));
disp("testingOutput")
disp(testingOutput(1:5,:));
%}

% How to print the id values correctly 
%{
x = trainingInput.Var1(1);
y = trainingOutput.Var1(1);
boolValue = x==y;
fprintf('Training input: %.f \n',x);
fprintf('Training output: %.f \n',y);
fprintf('Match: %.f \n',boolValue);
%}

% Divide the dataset into Training, Validation sets
% cross-validation partition for data. https://www.mathworks.com/help/stats/cvpartition.html
% Train - 75%
% Validation = 25%
primaryPartition = cvpartition(trainingInput.rating,'Holdout',0.25);
dataTrain = trainingInput(primaryPartition.training,1:3);
dataValidation = trainingInput((primaryPartition.test),1:3);
%dataTrain = trainingData(training(primaryPartition),:);
%dataValidation = trainingData(test(primaryPartition),:);

%{ Not using this for the semeval dataset
% Validation + Testing  = 25% of the total set
% The Validation set = 70 % of that 25% = 17.5% of the total set
% Testing set = 7.5% of the total set
%secondaryPartition = cvpartition(dataHeldOut.polarity,'HoldOut',0.3);
%dataValidation = dataHeldOut(training(secondaryPartition),:);
%dataTest = dataHeldOut(test(secondaryPartition),:);
%}

% For the sem eval dataset
% dataTest = testingInput;

% Checking: the partitions
disp("Tain partition");
disp(primaryPartition);
%disp("Test partition");
%disp(secondaryPartition);

% Double checking the sizes of the training and validation data
disp("dataTraining");
disp(size(dataTrain));
disp("dataValidation");
disp(size(dataValidation));

disp("before anything changes");
disp("input size");
disp(size(dataTesting.tweet));
disp("output size");
disp(size(dataTesting.rating));

% No longer using this 
% Input: the body if the tweet 
% inputTrain = dataTrain.tweet;
% inputValidation = dataValidation.tweet;


% Output: the sentiment of the tweet
% Convert this str2Num
%outputTrain = dataTrain.polarity;
%outputValidation = dataValidation.polarity;
%outputTest = dataTest.polarity;


%{ 
Checking: input and output
inputSize = size(inputTrain);
inputSize = inputSize(1);
for i = 1:inputSize
    fprintf("row %i  output: %s   input: %s \n",i, outputTrain(i), inputTrain(i));
end
inputSize = size(inputValidation);
inputSize = inputSize(1);
for i = 1:inputSize
    fprintf("row %i  output: %s   input: %s \n",i, outputValidation(i), inputValidation(i));
end
inputSize = size(inputTest);
inputSize = inputSize(1);
for i = 1:inputSize
    fprintf("row %i  output: %s   input: %s \n",i, outputTest(i), inputTest(i));
end
%}


%fig_a = figure;
%figure(fig_a);
%wordcloud(inputTrain);
%title("Training Data");

%fig_b = figure;
%figure(fig_b);

% function polarity5PointTo3Point is defined below
%outputTrain = arrayfun(@polarity5PointTo3Point, str2double(outputTrain));
%histogram(outputTrain)
%title('Training output')



 
% Print the raw tweet body here
%{
disp("Raw training")
disp(dataTrain(1:7,3));
disp("Raw validation")
disp(dataValidation(1:7,3));
%}

% Preprocess the data
% Convert the tweet body of type string to of type tokenizedDocument 
% See https://www.mathworks.com/help/textanalytics/ref/tokenizeddocument.html
dataTrain.tokenizedTweets = preprocessTweets(dataTrain.tweet);
dataValidation.tokenizedTweets = preprocessTweets(dataValidation.tweet);
dataTesting.tokenizedTweets = preprocessTweets(dataTesting.tweet);
disp("after tokenized");
disp("input size");
disp(size(dataTesting.tweet));
disp("output size");
disp(size(dataTesting.rating));

% Print all the training and val tweets
%{
disp("Processed training");
disp(dataTrain(:,3).tweet);
disp("Processed validation");
disp(dataValidation(:,3).tweet);
%}

disp("Processed training");
disp(dataTrain(1:5,:));
%disp(dataTrain(1:5,:).tokenizedTweets);
%disp(dataTrain(1:5,:).tokenizedTweets(1));
%disp(dataTrain(1,:).tokenizedTweets);

dataTrain.rating = categorical(dataTrain.rating);
dataValidation.rating = categorical(dataValidation.rating);
dataTesting.rating = categorical(dataTesting.rating);

disp("after categorical");
disp("input size");
disp(size(dataTesting.tweet));
disp("output size");
disp(size(dataTesting.rating));




% Get the word embedding using pretrained GloVe not word2vec to save time
wordEmbedding = downloadReadWordEmbedding(100);

% Remove empty tweets: we must also remove 
% These two lines are from the demo  
% but look at https://www.mathworks.com/help/textanalytics/ref/tokenizeddocument.removeemptydocuments.html
[~, idx] = removeEmptyDocuments(dataTrain.tokenizedTweets);
dataTrain(idx,:) = [];
%dataValidation
[~, idx] = removeEmptyDocuments(dataValidation.tokenizedTweets);
dataValidation(idx,:) = [];

%dataTesting
[~, idx] = removeEmptyDocuments(dataTesting.tokenizedTweets);
dataTesting(idx,:) = [];



disp("after remove");
disp("input size");
disp(size(dataTesting.tweet));
disp("output size");
disp(size(dataTesting.rating));



% Use the word embedding to convert the tokenized tweets into vectors

dataTrain.wordVec = prepData(wordEmbedding,dataTrain.tokenizedTweets);
dataValidation.wordVec = prepData(wordEmbedding,dataValidation.tokenizedTweets);
dataTesting.wordVec = prepData(wordEmbedding,dataTesting.tokenizedTweets);

disp("word vect input size");
disp("input size dataTesting.wordVec");
disp(size(dataTesting.wordVec));



%build LSTM
inputSize = wordEmbedding.Dimension;
outputSize = 180;
numClasses = 3;

layers = [ sequenceInputLayer(inputSize)
    lstmLayer(outputSize,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer('Name','Pos_Neg_Neu_Classification') ];

%https://www.mathworks.com/matlabcentral/answers/397588-how-is-it-possible-to-use-a-validation-set-with-a-lstm
%Do you have R2018b? ValidationData is supported for sequence networks in R2018b.
%'ValidationData',{dataValidation.wordVec,dataValidation.rating}, ...
options = trainingOptions('sgdm',...
    'InitialLearnRate',0.05,...
    'Plots','training-progress',...
    'MaxEpochs',10,...
    'Verbose',0);

doTraining = 1;
if doTraining
    net = trainNetwork(dataTrain.wordVec,dataTrain.rating,layers,options);
    save LSTMModel.mat net;
else 
    load LSTMModel.mat net;     
end

%%Save the trained network!!!!!!!!!!!!!!!!!
%{
to save
save('filename','VariableName(trained nnet object)')

to load
load filename
%}


% Test on the test dataset
[predictedOutput,~] = classify(net,dataTesting.wordVec);

disp("output size: predictedOutput");
disp(size(predictedOutput));
disp("output size: dataTesting.rating");
disp(size(dataTesting.rating));

accuracy = sum(predictedOutput == dataTesting.rating)/numel(predictedOutput);
disp("accuracy");
disp(accuracy);

disp("end");
return;


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


% I had already downloaded the glove twitter word embeddings and
% placed them in the same directory as the script
% Source see link above by Heather Gorr
function emb = downloadReadWordEmbedding(D)
% Load word embedding
    % Get it from http://nlp.stanford.edu/data/glove.twitter.27B.zip if it isnt
    % found in the workspace or current directories
    fname = "glove.twitter.27B."+D+"d"; 
    if ~exist('emb','var')                  % check workspace
        if exist(fname + '.mat','file')     % read embedding from .mat file
            c = load(fname + '.mat');
            emb = c.emb;
        elseif exist(fname + '.txt','file') % readWordEmbedding from .txt file
            emb = readWordEmbedding(fname + '.txt');
            save(fname + '.mat','emb'); 
        else                                % read from web, unzip, readWordEmbedding
            websave('glove.twitter.27B.zip',...
                'http://nlp.stanford.edu/data/glove.twitter.27B.zip');
            unzip('glove.twitter.27B.zip');
            emb = readWordEmbedding(fname + '.txt');
            save(fname + '.mat','emb'); 
        end
    end
end

