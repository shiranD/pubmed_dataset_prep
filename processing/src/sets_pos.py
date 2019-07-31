import argparse
import sys
import random
import re
import string

# shuffle sentneces
# split to N sets

def split(args):
  random.seed(10)

  ftrain = open(args.path2sets+"train", "w")
  ftest = open(args.path2sets+"test", "w")
  fvalid = open(args.path2sets+"valid", "w")
  ftrain_pos = open(args.path2sets+"train_pos", "w")
  ftest_pos = open(args.path2sets+"test_pos", "w")
  fvalid_pos = open(args.path2sets+"valid_pos", "w")

  for fold in range(args.numfolds):
    if fold==args.foldnum:

      with open(args.foldspath+"_"+str(fold), 'r') as f:
        for sentence in f:
          sent = sentence.strip()
          terms = [w.split('_')[0] for w in sent.split()]
          try:
              pos = [w.split('_')[1] for w in sent.split()]
          except:
              pos = []
              for w in sent.split():
                  out = w.split('_')
                  if len(out) == 1:
                      pos.append('CD')
                      print(out)
                  else:
                     pos.append(out[1])

          ftest.write(' '.join(terms))
          ftest.write('\n')
          ftest_pos.write(' '.join(pos))
          ftest_pos.write('\n')
   

    elif fold==args.foldnum+1 or (args.foldnum==args.numfolds-1 and fold==0):
      with open(args.foldspath+"_"+str(fold), 'r') as f:
        for sentence in f:
          sent = sentence.strip()
          terms = [w.split('_')[0] for w in sent.split()]
          try:
              pos = [w.split('_')[1] for w in sent.split()]
          except:
              pos = []
              for w in sent.split():
                  out = w.split('_')
                  if len(out) == 1:
                      pos.append('CD')
                      print(out)
                  else:
                     pos.append(out[1])
          fvalid.write(' '.join(terms))
          fvalid.write('\n')
          fvalid_pos.write(' '.join(pos))
          fvalid_pos.write('\n')
    else:
      with open(args.foldspath+"_"+str(fold), 'r') as f:
        for sentence in f:
          sent = sentence.strip()
          terms = [w.split('_')[0] for w in sent.split()]
          try:
              pos = [w.split('_')[1] for w in sent.split()]
          except:
              pos = []
              for w in sent.split():
                  out = w.split('_')
                  if len(out) == 1:
                      pos.append('CD')
                      print(out)
                  else:
                     pos.append(out[1])
          ftrain.write(' '.join(terms))
          ftrain.write('\n')
          ftrain_pos.write(' '.join(pos))
          ftrain_pos.write('\n')
     
  ftest.close()
  ftrain.close()
  fvalid.close()
  ftrain_pos.close()
  fvalid_pos.close()
  ftest_pos.close()

if __name__ == "__main__":

  parser = argparse.ArgumentParser(
      description='Split Data')
  parser.add_argument('--foldspath', type=str, help='folds path')
  parser.add_argument('--path2sets', type=str, help='path t output sets')
  parser.add_argument('--foldnum', type=int, help='current fold')
  parser.add_argument('--numfolds', type=int, help='total number of folds')
  args = parser.parse_args()
  split(args)
  
