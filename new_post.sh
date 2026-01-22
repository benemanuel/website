#!/bin/bash
# Script to create a new blog post

# Check if title is provided
if [ -z "$1" ]; then
    echo "Usage: ./new_post.sh \"Your Post Title\""
    echo "Example: ./new_post.sh \"The Architect of the Cage\""
    exit 1
fi

# Get the title from arguments
TITLE="$1"

# Generate slug (lowercase, replace spaces with hyphens, remove special chars)
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g' | sed 's/[^a-z0-9-]//g')

# Get today's date
DATE=$(date +%Y-%m-%d)

# Create filename
FILENAME="_posts/blog/${DATE}-${SLUG}.md"

# Check if file already exists
if [ -f "$FILENAME" ]; then
    echo "Error: Post already exists at $FILENAME"
    exit 1
fi

# Create the post from template
cat > "$FILENAME" << EOF
---
title: ${TITLE}
created: ${DATE}
authors:
  - avrahambenemanuel
---

# ${TITLE}

Write your content here...

EOF

echo "✓ Created new post: $FILENAME"
echo ""
echo "Next steps:"
echo "1. Edit the post: $FILENAME"
echo "2. Rebuild the site: docker-compose down && docker-compose up -d"
echo "3. View at: http://127.0.0.1:4007/${SLUG}"
echo ""

# Open in default editor if available
if command -v code &> /dev/null; then
    echo "Opening in VS Code..."
    code "$FILENAME"
elif command -v notepad++ &> /dev/null; then
    echo "Opening in Notepad++..."
    notepad++ "$FILENAME"
else
    echo "Open the file manually to start writing."
fi
