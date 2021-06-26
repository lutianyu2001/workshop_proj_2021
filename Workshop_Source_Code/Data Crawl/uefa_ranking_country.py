import requests
import re
from bs4 import BeautifulSoup
import pandas as pd

def getHtml(url):
    headers = {
    'user-agent':'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36',
    'Cookie': '_gid=GA1.2.1693463660.1621656508; idp_locale=en; gig_canary=false; geo.Country={%22countryName%22:%22China%22%2C%22countryCode%22:%22CHN%22%2C%22countryCodeShort%22:%22CN%22%2C%22fifaCountryCode%22:%22CHN%22%2C%22uefaCountry%22:false}; gig_bootstrap_3__N-xOlzJ6RNTtosKWZJvECS0U7fE12-78J9VzwEGBwwoaUXfji5hn-uaK9930RN5=idp_ver4; OptanonAlertBoxClosed=2021-05-22T04:08:56.827Z; ai_user=JZUMvg+h/zdmA/JHuqbb29|2021-05-22T04:08:57.244Z; _scid=b80d6fa2-2d0b-4de1-ac22-09e58bf0894e; BCSessionID=6cb4695e-9ce8-44c8-ad63-f1ea20657ca2; gig_canary_ver=12088-3-27027645; AKA_A2=A; OptanonConsent=isIABGlobal=false&datestamp=Sat+May+22+2021+13%3A10%3A36+GMT%2B0800+(%E4%B8%AD%E5%9B%BD%E6%A0%87%E5%87%86%E6%97%B6%E9%97%B4)&version=6.6.0&hosts=&consentId=6f5e60bb-ff09-40bd-8d00-36d2150a7d8b&interactionCount=2&landingPath=NotLandingPage&groups=1%3A1%2C4%3A1%2C2%3A1&AwaitingReconsent=false&geolocation=%3B; ai_session=DXQBH2x3qVVisYSPg4sfrh|1621656537349|1621660357390; ARRAffinity=018aede30f53259b1c399687e1a7d410badd27695496a909bac75aa9d59af498; ARRAffinitySameSite=018aede30f53259b1c399687e1a7d410badd27695496a909bac75aa9d59af498; RT="z=1&dm=www.uefa.com&si=acb1ab4c-377a-4207-a115-fe84260734a6&ss=koz9zenr&sl=7&tt=pgh&obo=5&rl=1"; _gat_UA-99223133-1=1; _gat_UA-99223133-39=1; _ga_X6QJTK7ZQG=GS1.1.1621659144.2.1.1621660367.0; _ga=GA1.1.1386798716.1621656508',
	'referer':'https://www.uefa.com/memberassociations/uefarankings/country/'
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
    country = []
    year = []
    year16 = []
    year17 = []
    year18 = []
    year19 = []
    year20 = []
    pts = []
    clubs = []
    team_code = []

    tbody = soup.find('tbody')
    for tr in tbody.find_all('tr'):
        pos_tmp = tr.find('span',class_='position')
        pos.append(pos_tmp.string)

        for span in tr.find_all('span',class_='team-code'):
            team_code.append(span.string.strip())

        for span in tr.find_all('span'):
            if (span['class'][0] == 'team-name' and span['class'][1] == 'visible-md'):
                country.append(span.string.strip())

        tds = []
        for td in tr.find_all('td',class_='table_member-season'):
            tds.append(td.string)
        year.append(tds)

        pts_tmp = tr.find('td',class_='table_member-points').string.strip()
        pts.append(pts_tmp)

        clubs_tmp = tr.find('td', class_='table_member-clubs').string.strip()
        clubs.append(clubs_tmp)

    for i in range(len(year)):
        year16.append(year[i][0])
        year17.append(year[i][1])
        year18.append(year[i][2])
        year19.append(year[i][3])
        year20.append(year[i][4])

    df = pd.DataFrame([pos,country,team_code,year16,year17,year18,year19,year20,pts,clubs],
                      index=['Pos','Country','team_code','16/17','17/18','18/19','19/20','20/21','Pts','Clubs']).transpose()
    return df

def save_to_csv(data,name):
    data.to_csv(name+'.csv', index = False,encoding='utf_8_sig')
    print('Finish!')

url = 'https://www.uefa.com/memberassociations/uefarankings/country/libraries//years/2021'
name = 'uefa_ranking_country_2016-2021'

html = getHtml(url)
soup = bf(html)
data = get_data(soup)
save_to_csv(data,name)

# print(soup)