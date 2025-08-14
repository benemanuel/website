"use strict";

/**
 * Reading Time Estimator
 * 
 * This script calculates the estimated reading time for blog posts
 * based on the number of words in the post content.
 */
document.addEventListener('DOMContentLoaded', function() {
  // Only run on post pages
  const postContent = document.querySelector('.post-content');
  if (!postContent) return;
  
  // Get the text content and calculate word count
  const text = postContent.textContent || postContent.innerText;
  const wordCount = text.trim().split(/\s+/).length;
  
  // Calculate reading time (average reading speed: 200 words per minute)
  const readingTimeMinutes = Math.max(1, Math.ceil(wordCount / 200));
  
  // Create the reading time element
  const readingTimeElement = document.createElement('span');
  readingTimeElement.className = 'reading-time';
  readingTimeElement.innerHTML = `${readingTimeMinutes} min read`;
  
  // Find where to insert the reading time (after the post title)
  const postHeader = document.querySelector('.post-header');
  if (postHeader) {
    const postMeta = postHeader.querySelector('.post-meta');
    if (postMeta) {
      postMeta.appendChild(document.createTextNode(' · '));
      postMeta.appendChild(readingTimeElement);
    } else {
      const postTitle = postHeader.querySelector('.post-title');
      if (postTitle) {
        postHeader.insertBefore(readingTimeElement, postTitle.nextSibling);
      }
    }
  }
  
  // Log for debugging
  console.log(`Estimated reading time: ${readingTimeMinutes} minutes (${wordCount} words)`);
});