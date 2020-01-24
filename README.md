# 590_LSTM_Project

2018 California General Election Data:

I wanted to analyze the sentiment of twitter data from around the 2018 General Election. I limited the scope of the of the investigation to the 2018 California General Election because of time constraints. The election data available on the New York Times website allowed me to enter the real names, percentages, and outcome from 9 races in California. I used Google to look up the twitter screen names for each of the 18 candidates. The Twitter API allows a developer to download tweets from a user by username. A small python application aided writing the election information to a file. Another small python application read the file containing the election information and download the past 1000 tweets from each of the candidates’ Twitter timeline. The tweets for each candidate were saved to a file. Next, raw twitter data was loaded into a Matlab struct so that the same preprocessing, tokenization, vector transformation methods could convert the data into an acceptable form for the LSTM network. Finally the sentiment of each tweet was  predicted using the LSTM network.  The sentiment count for each candidate’s tweets were appended to the table containing the election data.  

![](/images/total_sentiment_count.png)

![](/images/party.png)

![](/images/incumbent.png)

![](/images/table.png)
