#!/usr/bin/env python3

# Modified by: gpt-5-high from LMArena on 2025.08.28

# Usage:
# app --write-auto-sub --skip-download youtube.link
# ./srt_cleaner.py 'subtitle.vtt'

import argparse
import re
from pathlib import Path

# Words/markers to filter out (e.g., timing lines, closing tags)
BAD_WORDS = ('-->', '</c>')

# Remove leading ">> " or "&gt;&gt; " prefixes
PREFIX_RE = re.compile(r'^(?:&gt;|>){2}\s*')

def iter_cleaned(lines, bad_words=BAD_WORDS, prefix_re=PREFIX_RE):
    seen = set()
    for raw in lines:
        if any(b in raw for b in bad_words):
            continue
        line = prefix_re.sub('', raw)
        if line not in seen:
            seen.add(line)
            yield line


# Modified by: gpt-5-chat from LMArena on 2025.08.28
def main():
    parser = argparse.ArgumentParser(
        description='Clean a subtitle file: remove timing/tag lines, strip ">>" prefixes, deduplicate, and join all lines into one text block.'
    )
    parser.add_argument('input', help='Path to the subtitle file (e.g., .vtt)')
    parser.add_argument('-o', '--output', help='Output file path (default: input name with .txt)')
    parser.add_argument('--encoding', default='utf-8', help='Input file encoding (default: utf-8)')
    args = parser.parse_args()

    in_path = Path(args.input)
    out_path = Path(args.output) if args.output else in_path.with_suffix('.txt')

    with in_path.open('r', encoding=args.encoding, errors='replace') as infile, \
         out_path.open('w', encoding='utf-8') as outfile:
        cleaned = list(iter_cleaned(infile))
        joined_text = ' '.join(line.strip() for line in cleaned if line.strip())
        outfile.write(joined_text)

    print(f'Wrote cleaned subtitles to {out_path}')

if __name__ == '__main__':
    main()
