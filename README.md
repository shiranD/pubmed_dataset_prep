# pubmed_dataset_prep from xmls to folds ready for training
This repo extract punned xml's data process and prepares them for folds to run your cross validation experiment

The follwoing steps take place:

## Data Extraction (found under extraction folder)
1. extract the required fields of the xml (title, abstract, body)
2. retrieve the text of the given fields

## Data Processing (found under processing folder)
1. Text segmentation
2. POS addition (optional)
3. Text shuffling
4. Text split
5. Folds creation

## Reuired pre-requisites:
* ruby
* python 3
* [SciSpacy](https://allenai.github.io/scispacy/)
* [Spacy](https://spacy.io)
* SciSpacy's Medical tagger w/ ```pip install https://s3-us-west-2.amazonaws.com/ai2-s2-scispacy/releases/v0.2.0/en_core_sci_md-0.2.0.tar.gz```
* ```pip install ftfy``` fixes text for you
* slurm (is reccomended as it was built for parallel processing suitable for slurm)


This repo is modular and can be modified to address different needs: other field types can be extracted for the xml, POS can be added, is new xml files are added a single variable needs to be changed and so on.
