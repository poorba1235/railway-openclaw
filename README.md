# OpenClaw Fly.io Template

This repo packages **OpenClaw** for Fly.io with a small **/setup** web wizard.

## What you get

- **OpenClaw Gateway + Control UI** (served at `/` and `/openclaw`)
- A friendly **Setup Wizard** at `/setup` (protected by a password)
- Persistent state via **Fly Volume** (so config/credentials/memory survive redeploys)
- **Swap enabled** (to run comfortably on small 256MB/512MB instances)

## Fly.io deploy instructions

1) **Install Fly CLI**: `curl -L https://fly.io/install.sh | sh` (or `brew install flyctl`)
2) **Login**: `fly auth login`
3) **Launch**:
   ```bash
   fly launch --no-deploy
   ```
   - Accept the defaults (copy existing fly.toml settings if asked).
   - Say **Yes** to copy configuration to the new app.

4) **Create Volume** (Critical for persistence):
   ```bash
   fly volumes create openclaw_data --size 1
   ```
   (Use the same region as your app, e.g., `iad` or `lhr`. Check `fly.toml` if unsure.)

5) **Deploy**:
   ```bash
   fly deploy
   ```

Then:
- Visit `https://<your-app>.fly.dev/setup`
- Complete setup (Password: `test`)
- Visit `https://<your-app>.fly.dev/`

### Getting chat tokens

#### Telegram bot token
1) Open Telegram and message **@BotFather**
2) Run `/newbot` and follow the prompts
3) BotFather will give you a token that looks like: `123456789:AA...`
4) Paste that token into `/setup`

#### Discord bot token
1) Go to the Discord Developer Portal: https://discord.com/developers/applications
2) **New Application** → pick a name
3) Open the **Bot** tab → **Add Bot**
4) Copy the **Bot Token** and paste it into `/setup`
5) Invite the bot to your server (OAuth2 URL Generator → scopes: `bot`, `applications.commands`; then choose permissions)

## Local smoke test

```bash
docker build -t openclaw-fly .

docker run --rm -p 8080:8080 \
  -e PORT=8080 \
  -e SETUP_PASSWORD=test \
  -v $(pwd)/.tmpdata:/data \
  openclaw-fly

# open http://localhost:8080/setup (password: test)
```
