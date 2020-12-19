#!/bin/bash

SCRIPTS=../mosesdecoder/scripts
TOKENIZER=$SCRIPTS/tokenizer/tokenizer.perl
CLEAN=$SCRIPTS/training/clean-corpus-n.perl
NORM_PUNC=$SCRIPTS/tokenizer/normalize-punctuation.perl
REM_NON_PRINT_CHAR=$SCRIPTS/tokenizer/remove-non-printing-char.perl

src=cs
tgt=en
lang=cs-en
prep=en_cs_data
tmp=$prep/tmp
orig=en_cs_data
dev=("en_cs_data/dev/newstest2013.cs-en")
CORPORA=(
    "en_cs_data/train/train10000.cs-en"
)

mkdir -p $tmp

echo "pre-processing train data..."
for l in $src $tgt; do
    # rm $tmp/train.tags.$lang.tok.$l
    for f in "${CORPORA[@]}"; do
        cat $f.$l | \
            perl $NORM_PUNC $l | \
            perl $REM_NON_PRINT_CHAR | \
            perl $TOKENIZER -threads 8 -a -l $l >> $tmp/train.$lang.$l
    done
done

echo "pre-processing eval data..."
for l in $src $tgt; do
    # rm $tmp/dev.tags.$lang.tok.$l
    for f in "$dev"; do
        cat $f.$l | \
            perl $NORM_PUNC $l | \
            perl $REM_NON_PRINT_CHAR | \
            perl $TOKENIZER -threads 8 -a -l $l >> $tmp/dev.$lang.$l
    done
done

src=ro
echo "pre-processing test data..."
for l in $tgt $src; do
    if [ "$l" == "$src" ]; then
        t="src"
    else
        t="ref"
    fi
    grep '<seg id' $orig/test/test.$t.$l.sgm | \
        sed -e 's/<seg id="[0-9]*">\s*//g' | \
        sed -e 's/\s*<\/seg>\s*//g' | \
        sed -e "s/\’/\'/g" | \
    perl $TOKENIZER -threads 8 -a -l $l > $tmp/test.$l
    echo ""
done





