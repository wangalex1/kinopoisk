import json
import time
import pickle
import requests
from bs4 import BeautifulSoup as bs
# from fake_useragent import UserAgent
# u = UserAgent()


def save_pickle(o, path):
    with open(path, 'wb') as f:
        pickle.dump(o, f)


def load_pickle(path):
    with open(path, 'rb') as f:
        return pickle.load(f)


def get(url, headers, params, proxies):
    r = requests.get(url, headers=headers, params=params, proxies=proxies)
    return r

# for i in range(10):
#     try:
#         r = get(url, ...)
#         # 429
#         # r.raise_for_status()
#         # r.ok == (r.status_code < 400)
#         if r.status_code != 200:
#             raise Exception
#     except Exception as e:
#         # print(e)
#         time.sleep(0.5 + random.random())


url = "https://www.kinopoisk.ru/popular/films/"
params = {
    'quick_filters': 'serials',
    'tab': 'all',
}
headers = {
    'User-Agent': "Mozilla/5.0 (Windows; U; Windows NT 5.1; ru-RU) AppleWebKit/533.18.1 (KHTML, like Gecko) Version/5.0.2 Safari/533.18.5"
}
proxies = {
    'http': 'http://3.88.169.225:80',
    # 'https': 'https://165.227.223.19:3128',
}
# r = get(url, headers, params, proxies)

path = "kinopoisk.rsp"
# save_pickle(r, path)
r = load_pickle(path)
soup = bs(r.text, 'html.parser')
serials_info = soup.find_all(attrs={"class": "desktop-rating-selection-film-item"})
serials = []
for d in serials_info:
    info = {}
    rating = d.find(attrs={"class": "rating__value"}).text
    name = d.find(attrs={'class': 'selection-film-item-meta__name'}).text
    original_name = d.find(attrs={'class': 'selection-film-item-meta__original-name'}).text
    info['name'] = name
    info['original_name'] = original_name
    try:
        rating = float(rating)
        info['rating'] = rating
    except Exception:
        pass
    serials.append(info)

with open("50_serials.json", "w") as f:
    json.dump(serials, f, indent=2, ensure_ascii=False)

print(r)

# class KinopoiskParser:
#     def __init__(self, start_url, retry_number, sleep):
#         self.start_url = start_url
#         self.retry_number = retry_number
#         self.sleep = sleep
#         # TODO
#         self.headers = {}
#         pass
#
#     @staticmethod
#     def _get(self, *args, **kwargs):
#         for i in range(self.retry_number):
#             try:
#                 response = requests.get(*args, **kwargs)
#                 if response.status_code != 200:
#                     raise Exception("Status code != 200")
#                 return response
#             except:
#                 time.sleep(self.sleep)
#         return None
#
#     def run(self):
#         r = self._get(self.start_url, headers=self.headers)
#         pass
#
#     def parse(self):
#         pass
#
#     def save(self):
#         pass
#
#
# if __name__ == "__main__":
#     # TODO
#     start_url = ""
#     parser = KinopoiskParser(start_url, 5, 1)