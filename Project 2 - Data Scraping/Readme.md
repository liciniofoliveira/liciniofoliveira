# DATA SCAPING IN AMAZON WEBPAGE

![image](https://github.com/liciniofoliveira/liciniofoliveira/blob/main/Project%202%20-%20Data%20Scraping/data%20scraping%20header.jpg)

In this project i'll demonstrate a Data Scraping example using a product page in Amazon website
We'll be using Python, Requests, BeautifulSoup, Pandas and more!

### LIBRARIES USED:

- BeautifulSoup
- requests
- time
- datetime
- pandaS
- smtplib

### TIMER FOR DATA FETCH

I've setted a timer to check the price of the product(s) that was done doing this code: 

```python
while(True):
    check_price()
    time.sleep(86400)
 ```
 ### VARIABLE FOR CHECKING PRICE IN THE WEBPAGE
    ```python

    URL = 'https://www.amazon.es/s?k=supplements&i=hpc&crid=GH32N5SR8EER&sprefix=supplements%2Chpc%2C190&ref=nb_sb_noss_2'
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
        
The totality of the code can be seen in file ==Data Scaping Project - Amazon.md== within this folder.
