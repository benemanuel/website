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
 a. PAGE.HTML
	
    layout: pageAuto
    
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
9.  added google search and https://search.google.com/search-console/sitemaps/
a. https://benemanuel.github.io/website/googlexxx.html
b. benemanuel.geulah.org.il DNS TXT google-site-verification=xxx
c. https://rubygems.org/gems/jekyll-sitemap/versions/1.4.0?locale=en
d. whatever.xml
e. _config.yml
plugins:
  - jekyll-feed
  - jekyll-seo-tag
  - jekyll-sitemap
 10. independent docker setup as not to limit just github and to add searching (2do)
mkdir jekyll
cd jekyll/
docker run -v $(pwd):/site bretfisher/jekyll new .
git clone  https://github.com/benemanuel/website.git
cd website

 docker-compose.yml
# no version needed since 2020

services:
  jekyll:
    image: bretfisher/jekyll-serve
    restart: always
    volumes:
      - .:/site
    ports:
      - 127.0.0.1:4000:4000

docker-compose up -d
/etc/nginx/sites-available/blog.conf
 
 server {
#    listen [::]:443 ssl ipv6only=on; # managed by Certbot
#    listen 443 ssl; # managed by Certbot

    server_name  benemanuel.geulah.org.il;

    access_log  /var/log/nginx/benemanuel.access.log;
    error_log   /var/log/nginx/benemanuel.error.log;

    location / {
      proxy_pass http://localhost:4000;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }


    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/plausible.geulah.org.il/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/plausible.geulah.org.il/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot



}

server {
    if ($host = benemanuel.geulah.org.il) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


  server_name  benemanuel.geulah.org.il;
  listen       80;
  listen       [::]:80;
 # Force redirection to https on nginx side
  location / {
        return 301 https://$host$request_uri;
  }
  server_name  benemanuel.geulah.org.il;
  return 404; # managed by Certbot


}
server {
    if ($host = benemanuel.geulah.org.il) {
        return 301 https://$host$request_uri;
    } # managed by Certbot



    server_name  benemanuel.geulah.org.il;
    listen 80;
    return 404; # managed by Certbot


}


ln -s /etc/nginx/sites-available/blog.conf /etc/nginx/sites-enabled/.
certbot --nginx
service nginx stop
service nginx start

