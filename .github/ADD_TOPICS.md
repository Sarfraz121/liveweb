# 🏷️ Add Repository Topics

## Method 1: Using GitHub CLI (Recommended)

If you have GitHub CLI installed:

```bash
gh repo edit brandonqr/liveweb \
  --add-topic ai \
  --add-topic gemini \
  --add-topic gemini-3-flash \
  --add-topic voice-recognition \
  --add-topic web-builder \
  --add-topic code-generation \
  --add-topic react \
  --add-topic nodejs \
  --add-topic express \
  --add-topic vite \
  --add-topic speech-recognition \
  --add-topic ai-assistant \
  --add-topic web-development
```

## Method 2: Using GitHub Web Interface

1. Go to https://github.com/brandonqr/liveweb
2. Click the gear icon (⚙️) next to "About"
3. In the "Topics" field, add (comma-separated or one by one):
   ```
   ai, gemini, gemini-3-flash, voice-recognition, web-builder, code-generation, react, nodejs, express, vite, speech-recognition, ai-assistant, web-development
   ```
4. Click "Save changes"

## Method 3: Using GitHub API

If you have a GitHub Personal Access Token:

```bash
export GITHUB_TOKEN=your_token_here

curl -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/brandonqr/liveweb/topics" \
  -d '{"names":["ai","gemini","gemini-3-flash","voice-recognition","web-builder","code-generation","react","nodejs","express","vite","speech-recognition","ai-assistant","web-development"]}'
```

## Topics to Add

- `ai`
- `gemini`
- `gemini-3-flash`
- `voice-recognition`
- `web-builder`
- `code-generation`
- `react`
- `nodejs`
- `express`
- `vite`
- `speech-recognition`
- `ai-assistant`
- `web-development`
