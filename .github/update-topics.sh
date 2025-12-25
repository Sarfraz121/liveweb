#!/bin/bash
# Script to update repository topics using GitHub API

REPO_OWNER="brandonqr"
REPO_NAME="liveweb"
GITHUB_TOKEN="${GITHUB_TOKEN:-}"

TOPICS='["ai","gemini","gemini-3-flash","voice-recognition","web-builder","code-generation","react","nodejs","express","vite","speech-recognition","ai-assistant","web-development"]'

if [ -z "$GITHUB_TOKEN" ]; then
  echo "⚠️  GITHUB_TOKEN not set"
  echo "To use this script, set your GitHub token:"
  echo "  export GITHUB_TOKEN=your_token_here"
  echo ""
  echo "Or use GitHub CLI (gh):"
  echo "  gh repo edit brandonqr/liveweb --add-topic ai --add-topic gemini --add-topic gemini-3-flash --add-topic voice-recognition --add-topic web-builder --add-topic code-generation --add-topic react --add-topic nodejs --add-topic express --add-topic vite --add-topic speech-recognition --add-topic ai-assistant --add-topic web-development"
  exit 1
fi

echo "Updating repository topics..."
curl -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/topics" \
  -d "{\"names\":$TOPICS}"

echo ""
echo "✅ Topics updated!"
