FROM node:14.18.1-alpine


# https://stackoverflow.com/questions/49067625/how-can-i-use-chinese-in-alpine-headless-chrome
RUN apk add wqy-zenhei --update-cache --repository https://nl.alpinelinux.org/alpine/edge/testing

# pnpm
RUN sudo apk --no-cache add curl
RUN curl -f https://get.pnpm.io/v6.16.js | node - add --global pnpm

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
# https://gitlab.alpinelinux.org/alpine/aports/-/issues/5083#change-26720
RUN addgroup -S pptruser && adduser -S -G pptruser -s /bin/sh pptruser && mkdir -p /home/pptruser/Downloads /app && chown -R pptruser:pptruser /home/pptruser && chown -R pptruser:pptruser /app

# https://wiki.alpinelinux.org/wiki/Setting_up_a_new_user
# RUN apk add doas

# RUN echo "permit persist :pptruser" > /etc/doas.d/doas.conf

# Run everything after as non-privileged user.
USER pptruser
