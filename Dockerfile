FROM ruby:3.1-alpine
ENV PAGES_REPO_NWO="https://github.com/benemanuel/website"

# Install build tools required for native gem extensions
RUN apk add --no-cache build-base git

# Update RubyGems to the specific version required
RUN gem update --system 4.0.11

# Set working directory
WORKDIR /srv/jekyll

# Install bundler and github-pages using the updated system gems
RUN gem install bundler github-pages

# Copy site into image
COPY . .

# Install site dependencies using GitHub Pages gem set
RUN bundle install

# Build the static site
RUN JEKYLL_ENV=production bundle exec jekyll build

# NGINX will serve the /srv/jekyll/_site folder in a separate container