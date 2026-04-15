#!/bin/bash

set -e -u -o pipefail

module load uv
mkdir -p $SCRATCH/text2picto
uv venv -p python3.13 $SCRATCH/text2picto/env
source $SCRATCH/text2picto/env/bin/activate

rm -rf llm_text2picto
git clone https://github.com/benob/llm_text2picto.git llm_text2picto
uv pip install -r llm_text2picto/requirements.txt

export TIKTOKEN_RS_CACHE_DIR=./tiktoken
mkdir -p $TIKTOKEN_RS_CACHE_DIR
python -c "import openai_harmony; openai_harmony.load_harmony_encoding(openai_harmony.HarmonyEncodingName.HARMONY_GPT_OSS)"

hf download openai/gpt-oss-120b
hf download Qwen/Qwen3-Embedding-0.6B
