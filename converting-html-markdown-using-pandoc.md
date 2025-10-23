Converted using [Pandoc](https://pandoc.org/). Link: [Converting HTML to Markdown using Pandoc](https://www.cantoni.org/2019/01/27/converting-html-markdown-using-pandoc/)

---

<a href="#skip" class="visually-hidden">Skip to main content</a>

<a href="/" class="home-link">Brian Cantoni</a>

## Top level navigation menu

- [Home](/)

- [Archive](/blog/)

- [Tags](/tags/)

- [About](/about/)

- [Feed](/feed/feed.xml)

- 

# [Converting HTML to Markdown using Pandoc](https://www.cantoni.org/2019/01/27/converting-html-markdown-using-pandoc/)

- January 28, 2019
- (updated September 6, 2025)
- Tags:
- <a href="/tags/software/" class="post-tag">software</a>

<span pagefind-body=""> </span>

Markdown is a great plain text format for a lot of applications and is
often used to convert *to* HTML (for example on my WordPress blog here).
There are also some good use cases for the opposite: converting *from*
HTML into Markdown. I recently had such a case to convert some older
blog posts from raw HTML into Markdown found that
[Pandoc](https://pandoc.org/) made it really easy.

## What’s Pandoc

[Pandoc](https://pandoc.org/) is an open-source utility for converting
between a number of common (and rare) document types, for example plain
text, HTML, Markdown, MS Word, LaTeX, wiki, and so on. The output
formats list is really extensive, and people can write their own
“filters” to handle other formats as well, or to customize the existing
ones to their exact needs. The project tagline sums it up nicely:

> If you need to convert files from one markup format into another,
> pandoc is your swiss-army knife.
> 
> <img src="https://www.cantoni.org/images/pandoc-website-252x300.png" />
> 
> The Pandoc website lists all of the support file types it can convert
> between

## My Use Case

My particular use case was to convert about a dozen really old blog
posts from this website. I wrote these back in the early days when I
managed this site in [CityDesk](/?s=citydesk) and later migrated to
[MovableType](/?s=movabletype). The Google Search Console alerted me to
some crawler errors which turned out to be caused by raw PHP file
content being served instead of real HTML.

My approach for cleaning this up was as follows:

1. Convert HTML original articles into Markdown format
2. Do some manual cleanup editing and double-check links are still
   valid
3. Drop the Markdown into the appropriate Posts within WordPress
4. Modify my existing `.htaccess` files to do permanent (301) redirects
   for all of the old URLs

## Examples

### Simple HTML Example

With Pandoc installed, you can try a simple test pulling down the
installation instructions page:

    curl --silent https://pandoc.org/installing.html | pandoc --from html --to markdown_strict -o installing.md

To see the result, consider this HTML snippet from installing.html:

    <h2 id="compiling-from-source">Compiling from source</h2>
    <p>If for some reason a binary package is not available for your platform, or if you want to hack on pandoc or use a non-released version, you can install from source.</p>
    <h3 id="getting-the-pandoc-source-code">Getting the pandoc source code</h3>
    <p>Source tarballs can be found at <a href="https://hackage.haskell.org/package/pandoc" class="uri">https://hackage.haskell.org/package/pandoc</a>. For example, to fetch the source for version 1.17.0.3:</p>
    <pre><code>wget https://hackage.haskell.org/package/pandoc-1.17.0.3/pandoc-1.17.0.3.tar.gz
    tar xvzf pandoc-1.17.0.3.tar.gz
    cd pandoc-1.17.0.3</code></pre>

We can see the resulting Markdown turned out very well:

    ## Compiling from source
    
    If for some reason a binary package is not available for your platform, or if you want to hack on pandoc or use a non-released version, you can install from source.
    
    ### Getting the pandoc source code
    
    Source tarballs can be found at <a href="https://hackage.haskell.org/package/pandoc" class="uri">https://hackage.haskell.org/package/pandoc</a>. For example, to fetch the source for version 1.17.0.3:
    
        wget https://hackage.haskell.org/package/pandoc-1.17.0.3/pandoc-1.17.0.3.tar.gz
        tar xvzf pandoc-1.17.0.3.tar.gz
        cd pandoc-1.17.0.3

### My Blog Post Conversions

For my dozen old HTML articles, the straight conversion ended up being a
bit noisy, especially with the some old CMS template boilerplate around
the content which was no longer needed. To clean those up I used a
little bit of Sed to clean it up before conversion:

    #!/bin/bash
    echo "converting $1"
    cat $1 | sed '1,/<div class="asset-header">/d' | sed '/<div class="asset-footer">/,/<\/html>/d' | pandoc --wrap=none --from html --to markdown_strict > $1.md

(The above Sed commands clean up the HTML source in two passes: first
removing everything from top of file to `<div class="asset-header">`,
which is where the blog post started; and then removing all from
`<div class="asset-footer">` to the end of file.)

After that, I just needed to do some minor editing cleanups on the
Markdown files before bringing them in to WordPress. Success!

## Further Reading

There are a few good online converters you can try; keep in mind some of
these are limited in the number of characters they can handle:

- [Pandoc online demo](https://pandoc.org/try/)
- [Browserling](https://www.browserling.com/tools/html-to-markdown)
- [Turndown](http://domchristie.github.io/turndown/)

To learn more and go deeper on Pandoc, I recommend going through their
excellent [user’s guide](https://pandoc.org/MANUAL.html).

And finally a big recommendation for [Dillinger](https://dillinger.io/),
a great online tool for editing Markdown text with live HTML rendering.
I use that for writing these blog articles as well, before moving them
in to WordPress.

- ← Previous  
  [My Current Podcast Playlist](/2019/01/20/current-podcast-playlist/)
- Next →  
  [HTTP Request Inspectors](/2019/04/30/http-request-inspectors/)

---

**TL;DR:**

DDG Assist: To convert a website to Markdown using Pandoc, you can use the command line with a command like `curl --silent <URL> | pandoc --from html --to markdown_strict -o output.md`, replacing `<URL>` with the website's address. This will fetch the HTML content and convert it into a Markdown file named `output.md`.

```bash
curl --silent <URL> | pandoc --from html --to markdown_strict -o output.md
```

```bash
curl --silent https://www.cantoni.org/2019/01/27/converting-html-markdown-using-pandoc/ | pandoc --from html --to markdown_strict -o converting-html-markdown-using-pandoc.md
```
