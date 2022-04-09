import json
x = open("azkar.json","r",encoding='utf-8')
aList = json.loads(x.read())
x.close()
# aList = [{"name":"mohammad", "age":26},{"name":"mohammad", "age":20},{"name":"ali", "age":26},]
new = {}

for i in  aList:
    if( new.get(i["category"]) == None):
        new[i["category"]] = [i,]
    else:
        new[i["category"]].append(i)
    
jsonString = json.dumps(new,ensure_ascii=False)
# jsonString.JSONEncoder(encoding='utf-8')
jsonFile = open("data.json", "w",encoding='utf-8')
jsonFile.write(jsonString)
jsonFile.close()