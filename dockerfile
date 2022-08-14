FROM node:14.18.1-alpine

# Installs latest Chromium (100) package.
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Add user so we don't need --no-sandbox.
RUN addgroup -S pptruser && adduser -S -G pptruser pptruser && mkdir -p /home/pptruser/Downloads /app && chown -R pptruser:pptruser /home/pptruser && chown -R pptruser:pptruser /app

RUN echo "pptruser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/pptruser && chmod 0440 /etc/sudoers.d/pptruser

# Run everything after as non-privileged user.
USER pptruser
