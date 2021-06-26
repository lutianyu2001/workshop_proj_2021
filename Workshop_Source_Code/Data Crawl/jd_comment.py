import random
import time
import requests
import json
import re

def getHTML(url):
    try:
        header = {
                    'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36',
                    'Referer':"https://item.jd.com/",
                    'coockie' : '__jdu=1618996650644993303806; shshshfpa=f4467890-ff3b-bcbb-e5f6-5fc1974c1997-1618996651; shshshfpb=w7CHbZHWenBB%20W0IBteO%20Ew%3D%3D; __jdc=122270672; shshshfp=9a3682127737e41a5fa367ce40c4f285; areaId=19; ipLoc-djd=19-1609-41655-0; jwotest_product=99; unpl=V2_ZzNtbRYHQhAmC09SfEsPBGJXQVRKVkVCcQoRA38ZCVI3AUZbclRCFnUUR1BnGl8UZwQZXEdcQRVFCEdkexhdBGMBFFpHVnMlRQtGZHopXAJnChpVRVBHFHINQ1xzG14EZQoTWnJnQx1xOHYIP0AMQzkzEllCUEAVcglAVUsYbARXVXxdQ1ZCFHQLQlB8VFwCZwoaVUVQRxRyDUNccxteBGUKE1pyVnMW; CCC_SE=ADC_k89Wj61eLtqg7JEzmIFsmjP3u7w4YWbj8YrcnbmSomtBJ89gGD%2bodpvbEJ%2bNwX6ap1tSAb7oX6rEQEJcowlLeLJVuH14ysgGpju2m%2fDa0H45iJtWKDPFc3RMNKVHk3H3yVP%2bE0nyVjJ7%2fb%2fY9%2fH5IiamFfS9iaytZqq5NQI%2b%2bc4pzfTonlh00EeSAzIz03D%2bnGLEPEaJ0c7tlDu4i38G9lAyiIuzsrfhSK%2b01YQUq1zgWqxixVGxKwQkVbNeZkXvYt7VGL6nF%2bGHzPk%2bTZtaSxQ00SzF6BicL%2fKmGwdCcwHwv%2bdmOC%2fKzvXTKomCuSm4vDDoM%2fjVBkJeOyJze1obi78z7JK4Jleql0QZx1pMXeinKC8ZI6MqPqjtYytRgJrNXwZ87rpTwVLapRslSW7Qrm7jastI2lT7BczRdSEufdCvMk0oQMrNDDzg5N3wwseDWaNEhfZvh%2bfRIUoxkfYtfOSwxa11Lz8TOJ1KsfmjaWLUoq4wiFNYnOM1HNc1ygpBogkQL%2f2LNGFfjWDvrZ%2bzcw%3d%3d; shshshsID=547ddbbeac9906d3b13a3c063a6b530e_4_1621670672907; __jda=122270672.1618996650644993303806.1618996651.1621670640.1621670675.14; __jdb=122270672.1.1618996650644993303806|14.1621670675; __jdv=122270672|dh.8fenxiang.com|t_1000537640_|tuiguang|ea04b2876cb04eb8907f53ff51dfa3e7|1621670674653; user-key=51737665-112b-4c9e-8902-2aedf96b14a8; 3AB9D23F7A4B3C9B=V55NIZQ3IJJX2GJ223E24CM6A5G5GQCA6POCDJDXTLYY226SWQFVUGMMHDMKZAOXOGACMCD3P7VPF3UFIUZ4IOPFVU; JSESSIONID=9F89963A2D332880DBC0666163FBB235.s1'
        }
        r = requests.get(url,headers = header)
        r.raise_for_status()
        r.encoding = r.apparent_encoding
        return r.text
    except:
        return ("Error!")

def make_url(id,page):
    return "https://club.jd.com/comment/productPageComments.action?callback=fetchJSON_comment98&productId="+str(id)+"&score=0&sortType=5&page="+str(page)+"&pageSize=10&isShadowSku=0&rid=0&fold=1"

def get_data(id,page):
    li = []
    for k in range(0,page):
        a = make_url(id,k)
        print("page"+str(k))
        try:
            demo = getHTML(a)
            # print(demo)
            jd = json.loads(demo.lstrip("fetchJSON_comment98vv375(").rstrip(");"))
            j=1
            # print(jd['maxPage'])
            for i in jd['comments']:
                content = i['content']
                id = i['id']
                commentTime = i['creationTime']
                star = i['score']
                list = [id,commentTime,star,content.replace('\n', '').replace('\r', '')]
                li.append(list)
                print(list)
                j+=1
        except:
            pass
        time.sleep(random.randint(32,55))
    return li

id = 100010054677
pages = 2

li = []
li.extend(get_data(id,pages))
num = 0;
for i in li:
    num+=1
    # print(str(num))
    # print(i)
