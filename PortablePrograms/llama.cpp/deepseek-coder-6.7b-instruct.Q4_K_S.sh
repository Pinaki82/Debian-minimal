#!/bin/bash

# https://github.com/garyexplains/examples/blob/master/how-to-run-llama-cpp-on-raspberry-pi.md
# https://huggingface.co/TheBloke/Llama-2-7b-Chat-GGUF/tree/main
# https://huggingface.co/TheBloke/CodeLlama-7B-Instruct-GGUF/tree/main

# https://lmstudio.ai/
# https://github.com/deepseek-ai/deepseek-coder

cd /mnt/hdd/HOME/llama.cpp \

./main  -m models/TheBloke/deepseek-coder-6.7B-instruct-GGUF/deepseek-coder-6.7b-instruct.Q4_K_S.gguf --color \
       --ctx_size 2048 \
       -n -1 \
       -ins -b 256 \
       --top_k 10000 \
       --temp 0.2 \
       --repeat_penalty 1.1