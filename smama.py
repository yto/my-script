### 形態素解析WebAPI結果から形態素の表層文字列をリストとして返す関数
def sentence_to_tokens(query):
    import json
    from urllib import request
    APPID = "THISISAPEN"
    URL = "https://jlp.yahooapis.jp/MAService/V2/parse"
    params = json.dumps({
        "id": "1234-1",
        "jsonrpc": "2.0",
        "method": "jlp.maservice.parse",
        "params": { "q": query }
    }).encode()
    headers = {
        "Content-Type": "application/json",
        "User-Agent": "Yahoo AppID: {}".format(APPID),
    }
    req = request.Request(URL, params, headers)
    with request.urlopen(req) as res:
        body = res.read()
    obj = json.loads(body.decode())
    return [x[0] for x in obj['result']['tokens']]

### 入力文とマッチさせる辞書
sentence = '今日は良い天気です。エロいピエロです。'
dic = {
    '今': 'ima',
    '今日': 'kyou',
    '良い天':	'yoiten',
    '良い天気':	'yoitenki',
    'エロ':	'ero'
}
print('入力文:', sentence)

### (M1) 文を形態素に分割
tokens = sentence_to_tokens(sentence)
print('形態素:', tokens)

### (M2) 形態素区切り位置を保存
kugiri_positions = set(sum(len(token) for token in tokens[:i])
                       for i in range(0, len(tokens) + 1))
print('区切り位置:', kugiri_positions, '\n')

### (M3) 辞書にマッチさせる
for current_position in kugiri_positions:
    for entry in dic.keys():
        end_position = current_position + len(entry)
        if (end_position in kugiri_positions) & \
           (sentence[current_position:].startswith(entry)):
            print("MATCH!", current_position, end_position, entry, dic[entry])

