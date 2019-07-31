import argparse
import re
import ftfy
import string

def clean(args):
    """
    Preprocess the text file
    """
    fout = open(args.fout, 'w')
    plist = ["_","..","``", "...", "```", "''", "."]
    matcher = re.compile(r'([a-z])\1{2,}') # remove ltr repetitions of more than 2
    # replace different digits with regex
    regs = [('\d+\.\d+', '7'), ('\d+\-\d+', '9'), ('\[(, )*\]', ''), ('\[(; )*(,)?(; )*\]', ''), ('\((, )*\)', ''), ('\((; )*(,)?(; )*\)', ''), ('\[?■\]?',''), ('\(?■\)?',''), ('\[?●\]?',''), ('\(?●\)?',''), ('\[-\]', ''), ('‘', ''), (' – ', ''), ('”', ''), ('’', ''), (' — ', ''), ('…', ''), ('_+', ''), ('“', '')]
    with open(args.fdata, "r") as myfile:
        for line in myfile.readlines():
            line = line.lower()
            line = ftfy.fix_text(line)
            for (pattern, sub) in regs:
                data = re.sub(pattern, sub, line)
            sent = []
            data = data.strip()
            for w in data.split():
                found = [match.group() for match in matcher.finditer(w)]
                if not found:
                    sent.append(w)
            sent = [text for text in sent if not text in string.punctuation]
            sent = [text for text in sent if not text in plist]
            if len(sent) < 2: # remove short sentences
                continue
            fout.write(' '.join(sent))
            fout.write('\n')
        fout.close()

if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        description='rm refs')
    parser.add_argument('--fdata', type=str, help='corpus path')
    parser.add_argument('--fout', type=str, help='preprocessed file')
    args = parser.parse_args()
    clean(args)
