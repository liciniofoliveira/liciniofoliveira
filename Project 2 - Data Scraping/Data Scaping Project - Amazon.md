```python
# Importing Libraries

from bs4 import BeautifulSoup
import requests
import time
import datetime
import pandas as pd
import smtplib
```


```python
# Website Url and scraping code

URL = 'https://www.amazon.es/s?k=supplements&i=hpc&crid=GH32N5SR8EER&sprefix=supplements%2Chpc%2C190&ref=nb_sb_noss_2'

headers = {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/112.0"}


page = requests.get(URL, headers=headers)

soup1 = BeautifulSoup(page.content, "html.parser")
```


```python
soup2 = BeautifulSoup(soup1.prettify(), "html.parser")


```


```python
title = soup2.find('span', attrs={'class': 'a-size-base-plus a-color-base a-text-normal'}).get_text()

print(title)


```

    
                         Multivitaminas y Minerales - 450 Comprimidos (Suministro para 1+ año) - Todas las Vitaminas A,B,C,D3,E, Calcio, Zinc, Selenio – Multivitamínicos Activos Esenciales para Hombres y Mujeres
                        



```python
price = soup2.find('span', attrs={'class': 'a-price-whole'}).get_text()

print(price)

```

    
                           24,97
                          



```python
rating = soup2.find('span', attrs={'class': 'a-icon-alt'}).get_text()
print(rating)

```

    
                          4.5 de 5 estrellas.
                         



```python
# Clean up the data a little bit

price = price.strip()
title = title.strip()[:44] 
rating = rating.strip()

print(title)
print(price)
print(rating)


```

    Multivitaminas y Minerales - 450 Comprimidos
    24,97
    4.5 de 5 estrellas.



```python
# Create a Timestamp for your output to track when data was collected

import datetime

today = datetime.date.today()

print(today)
```

    2023-05-07



```python
# Create CSV and write headers and data into the file

import csv 

header = ['Title', 'Price', 'Rating', 'Date']
data = [title, price, rating, today]


with open('AmazonScrapeData.csv', 'w', newline='', encoding='UTF8') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerow(data)
    


```


```python
df = pd.read_csv('AmazonScrapeData.csv')

print(df)
```

                                              Title  Price               Rating  \
    0  Multivitaminas y Minerales - 450 Comprimidos  24,97  4.5 de 5 estrellas.   
    
             Date  
    0  2023-05-07  



```python
# Appending to the csv

with open('AmazonScrapeData.csv', 'a+', newline='', encoding='UTF8') as f:
    writer = csv.writer(f)
    writer.writerow(data)
```


```python
# Check Price variable

def check_price():
    URL = 'https://www.amazon.es/s?k=supplements&i=hpc&crid=GH32N5SR8EER&sprefix=supplements%2Chpc%2C190&ref=nb_sb_noss_2'

    headers = {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/112.0"}

    page = requests.get(URL, headers=headers)
    soup1 = BeautifulSoup(page.content, "html.parser")
    soup2 = BeautifulSoup(soup1.prettify(), "html.parser")
    title = soup2.find('span', attrs={'class': 'a-size-base-plus a-color-base a-text-normal'}).get_text()
    price = soup2.find('span', attrs={'class': 'a-price-whole'}).get_text()
    rating = soup2.find('span', attrs={'class': 'a-icon-alt'}).get_text()
    today = datetime.date.today()
    
    header = ['Title', 'Price', 'Rating', 'Date']
    data = [title, price, rating, today]

    with open('AmazonScrapeData.csv', 'w', newline='', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(header)
        writer.writerow(data)

    
```


```python
# Runs check_price after a set time and inputs data into your CSV

while(True):
    check_price()
    time.sleep(86400)
```


```python
import pandas as pd

df = pd.read_csv('AmazonScrapeData.csv')

print(df)

```


```python

```


```python

```
