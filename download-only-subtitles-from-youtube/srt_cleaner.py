import re
bad_words = ['-->','</c>'] 
prefix = re.compile(r"^&gt;&gt; ")


with open('example.en.vtt') as oldfile, open('newfile.txt', 'w') as newfile:
    for line in oldfile:
        if not any(bad_word in line for bad_word in bad_words):
            newfile.write(line)


with open('newfile.txt') as result:
    uniqlines = set(result.readlines())
    with open('sub_out.txt', 'w') as rmdup:
        mylst = map(lambda each: re.sub(prefix, "", each), uniqlines)
        print(mylst)
        rmdup.writelines(set(mylst))
