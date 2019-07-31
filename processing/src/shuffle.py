import argparse
import random
from collections import defaultdict
import numpy as np

def refine_corpus(args):
  """
  """
  random.seed(9001)
 
  # load file terms
  filelines = []
  with open(args.fdata, encoding = "utf-8") as f:
    for line in f:
      filelines.append(line)
  assign = np.random.randint(0, args.num+1, len(filelines))  
  bins = defaultdict(list)
  for i, item in enumerate(assign):
      if bins[item]:
          bins[item] += [i]
      else:
          bins[item] = [i]

  for (k,vs) in bins.items():
      with open(args.fout+"/"+str(k)+"/"+args.task,'w') as outfile:
          for v in vs:
              outfile.write(filelines[v])
          outfile.close() 

if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        description='Shuffle files from current split to a random split with seed')
    parser.add_argument('--fdata', type=str, help='data path')
    parser.add_argument('--fout', type=str, help='folder path')
    parser.add_argument('--num', type=int, help='number of folders (final files)')
    parser.add_argument('--task', type=str, help='task number')
    args = parser.parse_args()
    refine_corpus(args)

