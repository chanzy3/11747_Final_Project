#!/bin/bash

PRETRAIN=../mbart.cc25.v2/model.pt # fix if you moved the downloaded checkpoint
langs=ar_AR,cs_CZ,de_DE,en_XX,es_XX,et_EE,fi_FI,fr_XX,gu_IN,hi_IN,it_IT,ja_XX,kk_KZ,ko_KR,lt_LT,lv_LV,my_MM,ne_NP,nl_XX,ro_RO,ru_RU,si_LK,tr_TR,vi_VN,zh_CN
SRC=cs
TGT=en
NAME=cs-en
DATADIR=postprocessed/${NAME}
SAVEDIR=en-cs-checkpoint
fairseq-train ${DATADIR} \
  --encoder-normalize-before --decoder-normalize-before \
  --arch mbart_large --layernorm-embedding \
  --task translation_from_pretrained_bart \
  --source-lang ${SRC} --target-lang ${TGT} \
  --criterion label_smoothed_cross_entropy --label-smoothing 0.2 \
  --optimizer adam --adam-eps 1e-06 --adam-betas '(0.9, 0.98)' \
  --lr-scheduler polynomial_decay --lr 3e-05 --warmup-updates 2500 --total-num-update 80000 \
  --dropout 0.3 --attention-dropout 0.1 --weight-decay 0.0 \
  --max-tokens 512 --update-freq 2 \
  --save-interval 1 --save-interval-updates 10000 --keep-interval-updates 10 --no-epoch-checkpoints \
  --seed 222 --log-format simple --log-interval 2 \
  --restore-file ${PRETRAIN} \
  --reset-optimizer --reset-meters --reset-dataloader --reset-lr-scheduler \
  --langs ${langs} \
  --ddp-backend no_c10d \
  --skip-invalid-size-inputs-valid-test \
  --save-dir ${SAVEDIR}