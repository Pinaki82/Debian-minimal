@echo off
REM https://github.com/ggerganov/llama.cpp/releases
REM https://superuser.com/questions/225692/why-is-cd-in-windows-not-able-to-switch-between-drives
doskey cd=chdir/d $*
REM Enter the LLaMA program directory
N:
cd N:\llama.cpp\llama-b1226-bin-win-avx2-x64

REM Set the path to the LLaMA program directory
set LlamaPath=N:\llama.cpp\llama-b1226-bin-win-avx2-x64

@echo on

"%LlamaPath%\main.exe" ^
-m models\codellama-7b-instruct.Q2_K.gguf ^
--color ^
--ctx_size 2048 ^
-n -1 ^
-ins ^
-b 256 ^
--top_k 10000 ^
--temp 0.2 ^
--repeat_penalty 1.1