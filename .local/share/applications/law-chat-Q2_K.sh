#!/bin/bash

# https://github.com/garyexplains/examples/blob/master/how-to-run-llama-cpp-on-raspberry-pi.md
# https://huggingface.co/TheBloke/Llama-2-7b-Chat-GGUF/tree/main
# https://huggingface.co/TheBloke/CodeLlama-7B-Instruct-GGUF/tree/main

# https://huggingface.co/TheBloke/law-chat-GGUF
# wget https://huggingface.co/TheBloke/law-chat-GGUF/resolve/main/law-chat.Q2_K.gguf

# Others:
# https://huggingface.co/TheBloke/law-LLM-GGUF
# https://huggingface.co/law-ai/InLegalBERT (RAW)


cd /mnt/hdd2/llama.cpp \

./main  -m models/TheBloke/law-chat-GGUF/law-chat.Q2_K.gguf --color \
       --ctx_size 2048 \
       -n -1 \
       -ins -b 256 \
       --top_k 10000 \
       --temp 0.2 \
       --repeat_penalty 1.1
