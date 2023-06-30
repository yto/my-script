### 形態素解析WebAPIで形態素解析を行う部分
import json
from urllib import request
APPID = "THISISAPEN"
URL = "https://jlp.yahooapis.jp/MAService/V2/parse"
headers = {
    "Content-Type": "application/json",
    "User-Agent": "Yahoo AppID: {}".format(APPID),
}
param_dic = {
    "id": "1234-1",
    "jsonrpc": "2.0",
    "params": {}
}
def ma(query):
    param_dic['params']['q'] = query
    param_dic['method'] = "jlp.maservice.parse"
    params = json.dumps(param_dic).encode()
    req = request.Request(URL, params, headers)
    with request.urlopen(req) as res:
        body = res.read()
    return body.decode()

### 入力文とマッチさせる辞書
sentence = '今日は良い天気です。エロいピエロです。'
dic = {
    '今日': 'kyou',
    '良い天気':	'yoitenki',
    'エロ':	'ero'
}
print('入力文:', sentence)

### (M1) 文を形態素に分割
response = ma(sentence)
obj = json.loads(response)
tokens = [x[0] for x in obj['result']['tokens']]
print('形態素:', tokens)

### (M2) 形態素区切り位置を保存
kugiri_positions = set(sum(len(token) for token in tokens[:i])
                       for i in range(0, len(tokens) + 1))
print('区切り位置:', kugiri_positions, '\n')

### (M3) 辞書にマッチさせる
for i in kugiri_positions:
    for entry in dic.keys():
        to = i + len(entry)
        if (to in kugiri_positions) & (sentence[i:].startswith(entry)):
          print("MATCH!", i, to, entry, dic[entry])

