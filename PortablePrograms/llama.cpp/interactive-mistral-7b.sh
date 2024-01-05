#!/bin/bash

# https://github.com/garyexplains/examples/blob/master/how-to-run-llama-cpp-on-raspberry-pi.md
# https://huggingface.co/TheBloke/Llama-2-7b-Chat-GGUF/tree/main
# https://huggingface.co/TheBloke/CodeLlama-7B-Instruct-GGUF/tree/main

cd /mnt/hdd/HOME/llama.cpp \

# Add the following line before the line containing `--ctx_size 2048 \`.
#        -i -r "User:" -f prompts/custom_prompt_template.txt \
./main  -m models/TheBloke/Mistral-7B-v0.1-GGUF/mistral-7b-v0.1.Q2_K.gguf --color \
       --ctx_size 2048 \
       -n -1 \
       -ins -b 256 \
       --top_k 10000 \
       --temp 0.2 \
       --repeat_penalty 1.1
