# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a bilingual (English/Hebrew) Jekyll-based blog site with automatic RTL (right-to-left) text direction detection. The site is built using Jekyll 3.9.3 with the Minima theme and is hosted both on GitHub Pages and via a self-hosted Docker setup.

**Primary hosting:** https://benemanuel.geulah.org.il
**Original blog:** https://aviwollman.wordpress.com/ (migrated to Jekyll)

## Common Development Commands

### Local Development with Docker

```bash
# Build and serve the site locally
docker-compose up -d

# Stop the containers
docker-compose stop

# Rebuild from scratch
docker build -t website --no-cache=true .
docker run -p 4000:4000 -itd --name aviweb website
```

The site will be available at http://127.0.0.1:4007 (nginx) after building.

### Jekyll Commands

```bash
# Install dependencies
bundle install

# Build the site
bundle exec jekyll build

# Serve locally (traditional method, not Docker)
bundle exec jekyll serve

# Build with production environment
JEKYLL_ENV=production bundle exec jekyll build
```

### Search Index Generation

The site uses Whoosh for full-text search:

```bash
# Install search dependencies
pip install whoosh beautifulsoup4

# Generate search index from built site
python generate_search_index.py -s _site -o .
```

## Architecture and Key Patterns

### Automatic RTL/LTR Text Direction

The site handles both Hebrew and English content with automatic text direction detection. This is implemented through custom layouts:

- **pageAuto.html**: Base layout that splits content into paragraphs and applies `dir="auto"` to each
- **post.html**: Post layout that extends pageAuto, enabling automatic direction detection per paragraph
- **page.html**: Standard page layout (no auto-direction)

The key pattern (used in _layouts/post.html and _layouts/pageAuto.html):
```liquid
{% assign paragraphs = page.content | newline_to_br | strip_newlines | split: '<br />' %}
{% for p in paragraphs %}
<div dir="auto" class="post-content e-content" itemprop="articleBody">
{{ p }}
</div>
{% endfor %}
```

This splits content by line breaks and applies `dir="auto"` to each paragraph, allowing the browser to automatically detect and apply the correct text direction.

### Content Structure

- **_posts/blog/**: Main blog posts directory (bilingual content)
- **_posts/authors/**: Author information
- **_template/**: Contains sample.md template for new posts

Post frontmatter structure:
```yaml
---
title: "Post Title"
created: YYYY-MM-DD
authors:
  - avrahambenemanuel
---
```

### Layouts Hierarchy

- **default.html**: Base HTML structure
- **pageAuto.html**: Extends default, adds auto-direction for content
- **post.html**: Extends pageAuto, adds post metadata and schema.org markup
- **page.html**: Simple page layout without auto-direction
- **home.html**: Homepage listing layout

### Docker Architecture

The production Docker setup uses a two-container architecture:

1. **jekyll container**: Builds the static site using Ruby 3.3-alpine
   - Installs dependencies with bundler
   - Runs `jekyll build` to generate _site/
   - Exits after build completes (restart: "no")

2. **web container**: Serves the built site using nginx:alpine
   - Mounts _site/ directory as read-only
   - Exposes port 4007
   - Runs continuously (restart: always)

This separation keeps the serving container lightweight and secure.

### Plugins and Features

Active Jekyll plugins (_config.yml):
- jekyll-feed: RSS/Atom feed generation
- jekyll-seo-tag: SEO metadata
- jekyll-sitemap: XML sitemap for search engines

The site includes:
- Google Analytics integration (G-NVGSYBHJFV)
- Plausible analytics (_includes/plausible.html)
- Social media links (configured in _config.yml)
- Excerpt support with `<!--more-->` separator

## Important Notes

- The site uses both `created` and `date` in frontmatter - `created` is the custom field used in posts
- File encoding must support both Hebrew and English characters (UTF-8)
- Line breaks in content are semantically meaningful due to the paragraph-splitting approach for RTL/LTR
- The _site/ directory is gitignored - it's regenerated on each build
- GitHub Pages compatibility is maintained via the github-pages gem (version 228)

## Development Environment

The repository includes:
- **.devcontainer/**: VS Code Dev Container configuration
- **.obsidian/**: Obsidian vault configuration with RTL plugins (used for content authoring)
  - dynamic-rtl: Automatic RTL detection
  - obsidian-rtl: RTL support
  - editing-toolbar: Enhanced editing UI
  - templater-obsidian: Template management

## Common Issues

### Static index.html Override

If posts aren't appearing on the homepage:
- Check for a static `index.html` file in the root directory (should be gitignored)
- Jekyll generates `_site/index.html` from `index.md` - a root `index.html` will override this
- Delete or rename any root `index.html` and rebuild

### Clean URLs (Extensionless)

The site uses clean URLs (`/post-title` instead of `/post-title.html`). This requires:
- Custom `nginx.conf` with `try_files $uri $uri.html $uri/ =404;`
- The nginx.conf is mounted in docker-compose.yml

Without this configuration, individual post pages will return 404 when accessed without the `.html` extension.

## Deployment

The site is deployed via update.bat which uses plink to SSH to the remote server and execute update_website.sh. The remote setup uses the same Docker Compose configuration behind nginx as a reverse proxy with SSL.
