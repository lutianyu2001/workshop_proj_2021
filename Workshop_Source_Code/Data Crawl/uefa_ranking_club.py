import requests
import re
from bs4 import BeautifulSoup
import pandas as pd

def getHtml(url):
    headers = {
    'user-agent':'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36',
    'Cookie': '_gid=GA1.2.1693463660.1621656508; gig_bootstrap_3__N-xOlzJ6RNTtosKWZJvECS0U7fE12-78J9VzwEGBwwoaUXfji5hn-uaK9930RN5=idp_ver4; OptanonAlertBoxClosed=2021-05-22T04:08:56.827Z; ai_user=JZUMvg+h/zdmA/JHuqbb29|2021-05-22T04:08:57.244Z; _scid=b80d6fa2-2d0b-4de1-ac22-09e58bf0894e; BCSessionID=6cb4695e-9ce8-44c8-ad63-f1ea20657ca2; AKA_A2=A; _gat_UA-99223133-1=1; _gat_UA-99223133-39=1; idp_locale=en; gig_canary=false; gig_canary_ver=12088-3-27027750; OptanonConsent=isIABGlobal=false&datestamp=Sat+May+22+2021+15%3A24%3A35+GMT%2B0800+(%E4%B8%AD%E5%9B%BD%E6%A0%87%E5%87%86%E6%97%B6%E9%97%B4)&version=6.6.0&hosts=&consentId=6f5e60bb-ff09-40bd-8d00-36d2150a7d8b&interactionCount=2&landingPath=NotLandingPage&groups=1%3A1%2C4%3A1%2C2%3A1&AwaitingReconsent=false&geolocation=%3B; ai_session=vI4uqcLgr3hJvfhrRcD/A+|1621667948163|1621668277285; ARRAffinity=642d9fecd460d0f0f87f3d294dcf2112d51d6985f964b462220a8d3fa80309d6; ARRAffinitySameSite=642d9fecd460d0f0f87f3d294dcf2112d51d6985f964b462220a8d3fa80309d6; _ga_X6QJTK7ZQG=GS1.1.1621667945.3.1.1621668293.0; RT="z=1&dm=www.uefa.com&si=acb1ab4c-377a-4207-a115-fe84260734a6&ss=koz9zenr&sl=a&tt=pgh&obo=8&rl=1"; _ga=GA1.2.1386798716.1621656508',
    'referer':'https://www.uefa.com/memberassociations/uefarankings/club/'
	}
    r = requests.get(url, headers=headers)
    r.encoding = 'utf-8'
    print(r.status_code)
    return r.text

def bf(text):
    info = BeautifulSoup(text,"html.parser")
    return info

def save_to_csv(data,name):
    data.to_csv(name+'.csv', index = False,encoding='utf_8_sig')
    print('Finish!')

def get_data(soup):
    pos = []
    club_md = []
    club_sm = []
    country = []
    year = []
    year16 = []
    year17 = []
    year18 = []
    year19 = []
    year20 = []
    pts = []

    tbody = soup.find('tbody')
    for tr in tbody.find_all('tr'):
        pos_tmp = tr.find('span',class_='position')
        pos.append(pos_tmp.string)

        country_tmp = tr.find('td',class_='table_member-country').string.strip()
        country.append(country_tmp)

        tds = []
        for td in tr.find_all('td',class_='table_member-season'):
            tds.append(td.string)
        year.append(tds)

        team_name = tr.find('span',class_='table_team-name_block')
        for a in team_name.find_all('a'):
            if a['class'][1] == 'visible-md' :
                club_md.append(a.string.strip())
            if a['class'][1] == 'visible-sm' :
                club_sm.append(a.string.strip())

        # td1 = tr.find('td',class_='table_member-points')
        # pts_tmp = td1.find('strong').get_text()
        # print(pts_tmp)
        # # pts.append(pts_tmp)

    for i in range(len(year)):
        year16.append(year[i][0])
        year17.append(year[i][1])
        year18.append(year[i][2])
        year19.append(year[i][3])
        year20.append(year[i][4])

    df = pd.DataFrame([pos,club_md,club_sm,country,year16,year17,year18,year19,year20,pts],
                      index=['Pos','club_md','club_sm','Country','16/17','17/18','18/19','19/20','20/21','Pts']).transpose()
    return df

def save_to_csv(data,name):
    data.to_csv(name+'.csv', index = False,encoding='utf_8_sig')
    print('Finish!')

url = 'https://www.uefa.com/memberassociations/uefarankings/club/libraries//years/2021/'
name = 'uefa_ranking_club_2016-2021'

html = getHtml(url)
soup = bf(html)
data = get_data(soup)
save_to_csv(data,name)

# print(soup)