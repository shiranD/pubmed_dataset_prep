import argparse
import spacy
import scispacy

def segment(args):
    """
    Parse PubMed sentences
    """
    nlp = spacy.load("en_core_sci_md")
    for line in open(args.fname).readlines():
        try:
            doc = nlp(line)
            for sent in doc.sents:
                print(sent.text)
        except:
            pass
            #print("PROBLEMMMM", line)
if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        description='sentence segmentation')
    parser.add_argument('--fname', type=str, help='file of textual data')
    args = parser.parse_args()
    segment(args)
