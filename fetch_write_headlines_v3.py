import requests
from newsapi import NewsApiClient

newsapi = NewsApiClient(api_key='0faf785f68544799a7345903291eb336')

def get_business_economics_headlines(date):

    all_articles = newsapi.get_everything(
        q='economy',
        from_param=date,
        to=date,
        language='en',
        sort_by='publishedAt',
        
    )

    return all_articles

def print_headlines(headlines):
    with open(f'news_headlines_{date}.txt', 'w', encoding='utf-8') as file:
        for article in headlines['articles']:
            file.write(f'{article['title']}\n')
            print(f"Title: {article['title']}")


# Example usage
date = '2024-06-24'  # Replace with the desired date
all_articles = get_business_economics_headlines(date)

# print("Top Business Headlines:")
# print_headlines(top_headlines)

print("All Business and Economics Articles:")
print_headlines(all_articles)


