#!/bin/bash

module load arch/a100
module load uv

source $SCRATCH/text2picto/env/bin/activate
export TIKTOKEN_RS_CACHE_DIR=./tiktoken
export HF_HUB_OFFLINE=1
export TRANSFORMERS_OFFLINE=1

input_path=$1
output_path=$2
python llm_text2picto/llm_text2picto.py \
	--output_path="$output_path" \
	--model=openai/gpt-oss-120b \
	--dataset_path="$input_path" \
	--dataset_split=train \
	--do_rag \
	--resume \
        --rag_kbest=5 \
	--save_every=100 \
	--backend=vllm
