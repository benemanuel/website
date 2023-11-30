# rebuilding of blog started in 2004
https://aviwollman.wordpress.com/

many thanks to
1.  GitHUB - our host
2. Building github sites - Bill Raymond
https://bit.ly/3L2WEdZ
https://billraymond.github.io/my-jekyll-docker-website/
3. Migrating From WordPress to Jekyll on Github Pages - Robert Horvick - https://www.roberthorvick.com/blog/migrating-from-wordpress-to-jekyll-github-pages
4. WordPress to Markdown - https://github.com/lonekorean & https://github.com/flowershow/wordpress-to-markdown
5. Obsidian - https://help.obsidian.md/Home
	plugins -
	1. # Obsidian Dynamic RTL - https://github.com/mwxgaf/obsidian-dynamic-rtl
	2. # RTL SUPPORT - https://github.com/esm7/obsidian-rtl
	3.  # Obsidian Editing Toolbar - https://github.com/PKM-er/obsidian-editing-toolbar
6. favicon - https://medium.com/@xiang_zhou/how-to-add-a-favicon-to-your-jekyll-site-2ac2179cc2ed
7. rtl support for jekyll - https://stackoverflow.com/questions/47374051/how-to-write-rtl-text-in-jekyll-posts edited in _layouts directory
 a. page.html
 
    ***** page-original.html
	
    layout: default
	
    ***** page.html
	
    layout: pageAuto
	
    *****
    
    ***** page-original.html
    
      <div class="post-content">
        {{ content }}
      </div>
    
    ***** page.html
    
    {% assign paragraphs = page.content | newline_to_br | strip_newlines | split: '<br />' %}
    {% for p in paragraphs %}
    <div dir="auto">
    {{ p }}
    </div>
    {% endfor %}
    
    *****
    
 b. POST.HTML
        
    ***** post-original.html

    layout: default

    ***** post.html

    layout: pageAuto

    *****
    
    ***** post-original.html
    
      <div class="post-content e-content" itemprop="articleBody">
        {{ content }}
      </div>
    
    ***** post.html
    
    {% assign paragraphs = page.content | newline_to_br | strip_newlines | split: '<br />' %}
    {% for p in paragraphs %}
    <div dir="auto" class="post-content e-content" itemprop="articleBody">
    {{ p }}
    </div>
    {% endfor %} 
    
    *****

 c. HOME.HTML
 
    layout: pageAuto
    
8.  chatgpt 3.5 and google translate
9.  added google search 
a. https://benemanuel.github.io/website/googlecdc052d7f2d675f8.html
b. benemanuel.geulah.org.il DNS TXT google-site-verification=zZMuiIvfMduoK35KnAiKswTgAaF9zMdpPiSp-FPlUSI
c. https://rubygems.org/gems/jekyll-sitemap/versions/1.4.0?locale=en
d. whatever.xml
e. _config.yml
plugins:
  - jekyll-feed
  - jekyll-seo-tag
  - jekyll-sitemap