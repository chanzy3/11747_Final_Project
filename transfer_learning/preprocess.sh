#!/bin/bash

SRC=hi
TGT=en
SPM=../sentencepiece/build/src/spm_encode
# DATA_PREFIX=IITB.en-hi
DATA=hi-en
MODEL=../mbart.cc25.v2/sentence.bpe.model
TRAIN=train
VALID=dev
DEST=cs_en_spm
TEST=test
${SPM} --model=${MODEL} < ${DATA}/train.${SRC}-${TGT}.${SRC} > ${DATA}/train.spm.${SRC} &
${SPM} --model=${MODEL} < ${DATA}/train.${SRC}-${TGT}.${TGT} > ${DATA}/train.spm.${TGT}
${SPM} --model=${MODEL} < ${DATA}/dev.${SRC}-${TGT}.${SRC} > ${DATA}/dev.spm.${SRC} &
${SPM} --model=${MODEL} < ${DATA}/dev.${SRC}-${TGT}.${TGT} > ${DATA}/dev.spm.${TGT} &
# ${SPM} --model=${MODEL} < ${DATA}/${TEST}.en > ${DATA}/${TEST}.spm.en &
# ${SPM} --model=${MODEL} < ${DATA}/${TEST}.ro > ${DATA}/${TEST}.spm.ro


SRC=hi
TGT=en
DATA=hi-en
DICT=../mbart.cc25.v2/dict.txt
DEST=postprocessed
NAME=${SRC}-${TGT}
fairseq-preprocess \
  --source-lang ${SRC} \
  --target-lang ${TGT} \
  --trainpref ${DATA}/${TRAIN}.spm \
  --validpref ${DATA}/${VALID}.spm \
  --destdir ${DEST}/${NAME} \
  --thresholdtgt 0 \
  --thresholdsrc 0 \
  --srcdict ${DICT} \
  --tgtdict ${DICT} \
  --workers 70