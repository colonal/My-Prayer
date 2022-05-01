import re
import json
from robobrowser import RoboBrowser
# def Convert(a):
#     it = iter(a)
#     res_dct = dict(zip(it, it))
#     return res_dct
# browser = RoboBrowser(parser="lxml", history=True)

# browser.open("http://www.islih.com/view/7505")
# data = browser.find("div",{"id":"mw-content-text"})
# data = data.find_all("p")
# dataList = []
# v = 0
# print(len(data))
# for i in data:
#     # v+=1
#     if len(i.text) >22 and v != 0 and v !=114:#i.text != "بسم الله الرحمن الرحيم" and i.text != "بسم الله الرحمن الرحيم":# (v%2 == 0 or v == 15) and v!=16:

#         v+=1
#         dataList.append(i.text)
#         # dataList.append(v)
#         print(v)
    	
    	
# dataD = {}
# for i in range(len(dataList)):
# 	dataD[i] = dataList[i]

# fileWL = open("data1.json","w",encoding='utf-8')
# jsonString = json.dumps(dataD,ensure_ascii=False)
# aList = fileWL.write(jsonString)
# fileWL.close()
# print("Done")
    
    
    
# text = "بسم الله الرحمن الرحيم (1)الحمد لله رب العالمين (2) الرحمن الرحيم (3) مالك يوم الدين (4) إياك نعبد وإياك نستعين (5) اهدنا الصراط المستقيم (6) صراط الذين أنعمت عليهم غير المغضوب عليهم ولا الضالين (7)"
fileData = open("data.json","r",encoding='utf-8')
dataList = json.loads(fileData.read())
fileData.close()
print(len(dataList))
dataList[0] = "بسم الله الرحمن الرحيم (1)الحمد لله رب العالمين (2) الرحمن الرحيم (3) مالك يوم الدين (4) إياك نعبد وإياك نستعين (5) اهدنا الصراط المستقيم (6) صراط الذين أنعمت عليهم غير المغضوب عليهم ولا الضالين (7)"
dataList = list(dataList.values())
print(dataList[0])



fileR = open("ayah.json","r",encoding='utf-8')
aList = json.loads(fileR.read())
fileR.close()






mainCount = 0
for text in dataList:
	if mainCount == 114:
		break
	x = re.split("\([0-9]+\)", text)
	count = 0
	print(mainCount)
	l = aList[mainCount]["verses"]
 	
	for i in l:
		try:
			i["cleanText"] = x[count]
			count += 1
		except Exception as e:
			print(f"E: {e}")
			# print(len(i["cleanText"]))
			print(len(x))
			print(x)
			exit()

	mainCount +=1
	
 	

fileW = open("azkar1.json","w",encoding='utf-8')
jsonString = json.dumps(aList,ensure_ascii=False)
aList = fileW.write(jsonString)
fileW.close()
