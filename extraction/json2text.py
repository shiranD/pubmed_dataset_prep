import json
import sys

def textify(input_path, ids):
  ids = int(ids)
  if ids < 10:
    ids = '0'+str(ids)
  else:
    ids = str(ids) 
  filename = input_path + "/" +ids + ".txt"
  for line in open(filename, "r").readlines():
    j = json.loads(line)
    try:
      print(j["title"])
    except:
      pass
    try:
      print(j["abstract"]["full"])
    except:
      pass
    try: 
      print(j["body"]["full"])
    except:
      pass

input_path = sys.argv[1]
ids = sys.argv[2]
textify(input_path, ids)
