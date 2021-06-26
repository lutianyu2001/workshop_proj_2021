import requests
import re
from bs4 import BeautifulSoup
import pandas as pd

def getHtml(url):
    headers = {
    'user-agent':'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36',
	}
    r = requests.get(url, headers=headers)
    r.encoding = 'utf-8'
    print(r.status_code)
    return r.text

def bf(text):
    info = BeautifulSoup(text,"html.parser")
    return info

def get_data(text):
    # print(text)
    rank = []
    team = []
    tot_points = []
    pre_points = []
    table = text.find('table')
    tbody = table.tbody
    for tr in tbody.find_all('tr'):
        team_tmp = tr.find('span',class_='fi-t__nText').string
        rank_tmp = tr.find('span',class_='text').string
        team.append(team_tmp)
        rank.append(rank_tmp)
        for td in tr.find_all('td'):
            # print(td['class'][1])
            if(td['class'][1] == 'fi-table__points'):
                tot_points_tmp = td.string
                tot_points.append(tot_points_tmp)
            if(td['class'][1] == 'fi-table__prevpoints'):
                pre_points_tmp = td.string
                pre_points.append(pre_points_tmp)
    df = pd.DataFrame([rank,team,tot_points,pre_points],index=['RNK','TEAM','TOTAL_POINTS','PREVIOUS_POINTS']).transpose()
    return df

def save_to_csv(data,name):
    data.to_csv(name+'.csv', index = False,encoding='utf_8_sig')
    print('Finish!')

url = 'https://www.fifa.com/fifa-world-ranking/ranking-table/men/'
name = 'fifa_ranking'

html = getHtml(url)
soup = bf(html)
data = get_data(soup)
save_to_csv(data,name)