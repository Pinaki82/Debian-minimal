#!/bin/bash

# https://github.com/garyexplains/examples/blob/master/how-to-run-llama-cpp-on-raspberry-pi.md
# https://huggingface.co/TheBloke/Llama-2-7b-Chat-GGUF/tree/main
# https://huggingface.co/TheBloke/CodeLlama-7B-Instruct-GGUF/tree/main

# https://huggingface.co/tsunemoto/MiniChat-1.5-3B-GGUF
# https://huggingface.co/tsunemoto/MiniChat-1.5-3B-GGUF/resolve/main/minichat-1.5-3b.Q2_K.gguf

cd /mnt/hdd/HOME/llama.cpp \

./main  -m models/tsunemoto/MiniChat-1.5-3B-GGUF/minichat-1.5-3b.Q2_K.gguf --color \
       --ctx_size 2048 \
       -n -1 \
       -ins -b 256 \
       --top_k 10000 \
       --temp 0.2 \
       --repeat_penalty 1.1
