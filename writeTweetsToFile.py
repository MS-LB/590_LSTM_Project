# michael scheid
import twitter_credentials
from TwitterAPI import TwitterAPI, TwitterPager


line_break = "\n"

api = TwitterAPI(twitter_credentials.CONSUMER_KEY, twitter_credentials.CONSUMER_SECRET, auth_type='oAuth2')

#open canididates.txt
path_to_file = ''
canididates_file = open(path_to_file, 'r')

# key -> value pairs.
# screen_names -> real name
name_map = dict({})

var_names = canididates_file.readline()
print("var_names:"+var_names)
for next_line in canididates_file:
    #print(next_line)
    split_line = next_line.split(",")
    name = split_line[0]
    screen_name = split_line[1]
    name_map[screen_name] = name

canididates_file.close()


for key in name_map:
    SCREEN_NAME = key
    REAL_NAME = name_map[key]
    print("Getting tweets from:"+REAL_NAME+"  @"+SCREEN_NAME)

    pager = TwitterPager(api, 'statuses/user_timeline', {'screen_name': SCREEN_NAME, 'count': 1000})

    outfile = open('rawTwitterData/' + SCREEN_NAME+".txt", 'w+')
    count = 0

    for item in pager.get_iterator(wait=3.5):
        if 'text' in item:
            count += 1
            tweet_body = unicode(item['text']).encode('utf-8')
            tweet_body.strip("\t").strip("\n")
            outfile.write('"'+tweet_body+'"'+line_break)
        if count > 1001:
            print("number of tweets:"+str(count))
            break
    outfile.close()



