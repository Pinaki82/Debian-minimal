#!/bin/bash

# https://github.com/garyexplains/examples/blob/master/how-to-run-llama-cpp-on-raspberry-pi.md
# https://huggingface.co/TheBloke/Llama-2-7b-Chat-GGUF/tree/main
# https://huggingface.co/TheBloke/CodeLlama-7B-Instruct-GGUF/tree/main

# https://huggingface.co/alexedelsburg/Puma-3b-GGUF
# https://huggingface.co/alexedelsburg/Puma-3b-GGUF/tree/main

cd /mnt/hdd/HOME/llama.cpp \

# Add the following line before the line containing `--ctx_size 2048 \`.
#        -i -r "User:" -f prompts/custom_prompt_template.txt \
./main  -m models/TheBloke/Puma-3b-Q4_1-GGUF/puma-3b.q4_1.gguf --color \
       --ctx_size 2048 \
       -n -1 \
       -ins -b 256 \
       --top_k 10000 \
       --temp 0.2 \
       --repeat_penalty 1.1
