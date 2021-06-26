import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import matplotlib.ticker as tck
import numpy as np
import pandas as pd
from PIL import Image 
from .plt_data import plot_data
from .upload import UP
import os


ip_global="192.168.56.101"
port_global="6234"

pic1_mark=1
pic2_mark=0

def getPicture(_event, _name, _date1, _date2):
    # _event ="all"
    # _name = "scotland"
    # _date1 = "2012-01"
    # _date2 = "2015-06"

    global ip_global, port_global
    global pic1_mark, pic2_mark

    title = "points changing chart of " + _name

    try:
        df = plot_data(event_type=_event, name=_name, date1=_date1, date2=_date2)
    except Exception:
        return ''

    # line chart
    # df.plot(x='date', y='pts', kind='scatter')

    date_raw = df["date"]
    date = ["Before"]
    for d in date_raw:
        if d == "Before":
            continue
        date.append(np.datetime64(d))

    points = np.array(df["pts"]).tolist()

    fig, ax = plt.subplots(1, 1)

    tick_spacing = int((len(date) - 1) / 5)
    ax.xaxis.set_major_locator(tck.MultipleLocator(tick_spacing))

    plt.plot(date, points)
    plt.xticks(rotation=30, fontsize=8)
    plt.ylabel("Points", fontsize=14)
    plt.title(title, fontsize=17)

    fig.savefig(fname="pic_raw.png")

    im = Image.open('pic_raw.png')
    imBackground = im.resize((1200, 900))

    name = str(_event) + str(_name) + str(_date1) + str(_date2) + '.png'
    imBackground.save('../tmp/' + name,'PNG')
    
    url = "http://" + ip_global +':'+ port_global + "/tmp/" + name

    print("url:", url)
    return url

if __name__ == "__main__":
    url = getPicture("all", "scotland", "2012-01", "2015-06")
    