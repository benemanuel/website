FROM ruby:3.1-alpine

# Install build tools required for native gem extensions
RUN apk add --no-cache build-base git

# Set working directory
WORKDIR /srv/jekyll

# Install github-pages (includes correct Jekyll and pinned gems)
RUN gem install bundler github-pages

# Copy site into image
COPY . .

# Install site dependencies using GitHub Pages gem set
RUN bundle install

# Build the static site
RUN JEKYLL_ENV=production bundle exec jekyll build

# NGINX will serve the /srv/jekyll/_site folder in a separate container
