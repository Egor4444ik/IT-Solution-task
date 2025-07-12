import requests
from bs4 import BeautifulSoup

def parseImage(query):
    url = f"https://www.google.com/search?q={query}&tbm=isch"
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    images = soup.find_all('img')[1:]

    img = images[0]
    img_url = img['src']
    return requests.get(img_url).content