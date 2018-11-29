% Load the data Semeval 2017

% Define the directory
%trainingDir = "/Users/mjscheid/Desktop/590_Project/datasets/SemevalData_Part/Training/";
testingDir = "/Users/mjscheid/Desktop/590_Project/datasets/SemevalData_Part/Testing2/";
trainingDir = "/Users/mjscheid/Desktop/590_Project/datasets/SemevalData_Full/Training/";
%testingDir = "/Users/mjscheid/Desktop/590_Project/datasets/SemevalData_Full/Testing/";

% Define the file names
trainingDataInputFileName = "SemEval2017-task4-dev.subtask-A.english.INPUT.txt";
trainingDataOutputFileName = "twitter-2016test-A-English.txt";
testingDataInputFileName = "SemEval2017-task4-test.subtask-A.english.txt";
testingDataOutputFileName = "SemEval2017_task4_subtaskA_test_english_gold.txt";

% Define the full file path
trainingInputFile = trainingDir + trainingDataInputFileName;
trainingOutputFile = trainingDir + trainingDataOutputFileName;
testingInputFile = testingDir + testingDataInputFileName;
testingOutputFile = testingDir + testingDataOutputFileName;

% Build a table from the data from the text file
trainingInput = readtable(trainingInputFile,'TextType','string');
trainingOutput = readtable(trainingOutputFile,'TextType','string');
testingInput = readtable(testingInputFile,'TextType','string');
testingOutput = readtable(testingOutputFile,'TextType','string');


disp("Training data:");
disp("input size");
disp(size(trainingInput));
disp("output size");
disp(size(trainingOutput));




% check the test data
disp("testing data:");
disp("input size");
disp(size(testingInput));
disp("output size");
disp(size(testingOutput));


disp(testingInput(1:4,:));
disp(testingOutput(1:4,:));


idx_output  = ismember(testingOutput.Var1, testingInput.Var1);
testingOutput(~idx_output,:)=[];
idx_input  = ismember(testingInput.Var1, testingOutput.Var1);
testingInput(~idx_input,:)=[];

disp("testing data:");
disp("input size");
disp(size(testingInput));
disp("output size");
disp(size(testingOutput));

disp(testingInput(1:4,:));
disp(testingOutput(1:4,:));


% Join the testing input and output into one table
dataTesting = testingInput;
dataTesting.Var2 = testingOutput.Var2;

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

%{
%File as in the python project dir move it after data collection
candidatesFile = "/Users/mjscheid/PycharmProjects/twitter_1/Candidates/Candidates.txt";
%canFile = "/Users/mjscheid/Desktop/590_Project/datasets/Candidates.txt";
candidatesData = readtable(candidatesFile,'TextType','string','Delimiter',',','ReadVariableNames',1);
disp("candidates");
disp(candidatesData(:,:));
disp(candidatesData(1,:).screen_name);

disp("can size");
canSize = size(candidatesData(:,1));
tweetDir = '/Users/mjscheid/PycharmProjects/twitter_1/rawTwitterData/';
for i=1:canSize(1)
    tweetFile = tweetDir+ strcat(candidatesData(i,:).screen_name,".txt");
    disp(tweetFile)
    tweetTable1 = readtable(tweetFile,'TextType','string','ReadVariableNames',0);
    disp(summary(tweetTable1));
    disp(tweetTable1);
end
%}

%{
tweetFile = tweetDir+ strcat(candidatesData(1,:).screen_name,".txt");
disp(tweetFile)
tweetTable1 = readtable(tweetFile,'TextType','string','ReadVariableNames',0);
disp(summary(tweetTable1));
disp(tweetTable1);
%}

%{
tweetFileHandle = fopen('fgetl.m');
tline = fgetl(tweetFileHandle);
while ischar(tline)
    disp(tline)
    tline = fgetl(tweetFileHandle);
end
fclose(tweetFileHandle);
%}



%candidatesData.tweets = 
%tweets = readtable()


% Print candidates table and how to access a cell 
%{
disp( strcat("candidates from ",canFile) );
disp(canData);
disp(canData.Properties);
% How to access a cell
party_2a = canData.party(2);
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


% check the test data
disp("before anything changes");
disp("input size");
disp(size(dataTesting.tweet));
disp("output size");
disp(size(dataTesting.rating));

%{
fig_a = figure;
figure(fig_a);
wordcloud(dataTrain.tweet);
title("Training Data");

fig_b = figure;
figure(fig_b);
wordcloud(dataTesting.tweet);
title("Testing Data");
%}

%fig_b = figure;
%figure(fig_b);


% Preprocess the data
% Convert the tweet body of type string to of type tokenizedDocument 
% See https://www.mathworks.com/help/textanalytics/ref/tokenizeddocument.html
dataTrain.tokenizedTweets = preprocessTweets(dataTrain.tweet);
dataValidation.tokenizedTweets = preprocessTweets(dataValidation.tweet);
dataTesting.tokenizedTweets = preprocessTweets(dataTesting.tweet);


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


%build LSTM RNN
inputSize = wordEmbedding.Dimension;
outputSize = 180;
numClasses = 3;

%{
    %Inital test setup
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
%}

%lstmLayer(outputSize,'OutputMode','sequence')
%lstmLayer(outputSize,'OutputMode','last')
layers = [ sequenceInputLayer(inputSize)
    lstmLayer(outputSize,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer('Name','Pos_Neg_Neu_Classification') ];


	options = trainingOptions('sgdm',...
    'InitialLearnRate',0.05,...
    'Plots','training-progress',...
    'MaxEpochs',10,...
    'Verbose',0);


doTraining = 0;
if doTraining
    disp("Now Training the network");
    net = trainNetwork(dataTrain.wordVec,dataTrain.rating,layers,options);
    %save LSTMModel.mat net;
    save LSTM_NN.mat net
    disp("saved the network in LSTM_NN.m");
else 
    disp("load pretrained network");
    %load LSTMModel.mat net;
    load LSTM_NN.mat net
end

% Test on the test dataset
[predictedOutput,~] = classify(net,dataTesting.wordVec);

disp("output size: predictedOutput");
disp(size(predictedOutput));
disp("output size: dataTesting.rating");
disp(size(dataTesting.rating));

accuracy = sum(predictedOutput == dataTesting.rating)/numel(predictedOutput);
disp("accuracy");
disp(accuracy);

%todo run the election twitter data through here
% For each line in the file
    % get the twitter body
    % run it throught the preprocessor
    % use the word emb to get line.wordVec
    % [predictedOutput,~] = classify(net,currentTweet.wordVec);
    % write append the predicted value to the row???
    % Save the file
    


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

