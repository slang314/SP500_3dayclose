from textblob import TextBlob
import spacy
import pandas as pd
import win_unicode_console
win_unicode_console.enable()

nlp = spacy.load('en_core_web_sm')

headlines_in = 'news_headlines_2024-06-24.txt_cleaned.csv'

def analyze_sentiments_and_write_to_csv():
    
    with open(headlines_in, 'r') as file:
        headlines = file.readlines()

    sentiments = []

    for headline in headlines:
        
        headline_clean = headline.strip()
        
        blob = TextBlob(headline_clean)
        
        polarity = blob.sentiment.polarity
        subjectivity = blob.sentiment.subjectivity
        
        
        sentiments.append([headline_clean, polarity, subjectivity])

    df = pd.DataFrame(sentiments, columns=['Headline', 'Polarity', 'Subjectivity'])

    avg_polarity = df['Polarity'].mean()
    avg_subjectivity = df['Subjectivity'].mean()

    avg_df = pd.DataFrame([['Averages', avg_polarity, avg_subjectivity]], columns=['Headline', 'Polarity', 'Subjectivity'])
    print(f'polarity: {avg_polarity}')
    print(f'subjectivity {avg_subjectivity}')

    df = pd.concat([df, avg_df], ignore_index=True)

    df.to_csv(f'news_sentiments_{headlines_in}.csv', index=False)
    return "Sentiment data written to CSV."

result = analyze_sentiments_and_write_to_csv()

