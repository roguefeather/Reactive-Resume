# --- Release Image ---
    FROM base AS release
    ARG NX_CLOUD_ACCESS_TOKEN
    
    # Install Chrome dependencies for Puppeteer
    RUN apt update && apt install -y \
        dumb-init \
        fonts-liberation \
        libappindicator3-1 \
        libasound2 \
        libatk-bridge2.0-0 \
        libatk1.0-0 \
        libcups2 \
        libdbus-1-3 \
        libgdk-pixbuf2.0-0 \
        libnspr4 \
        libnss3 \
        libx11-xcb1 \
        libxcomposite1 \
        libxdamage1 \
        libxrandr2 \
        xdg-utils \
        wget \
        --no-install-recommends && rm -rf /var/lib/apt/lists/*
    
    # Puppeteer environment flags
    ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
        PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable \
        TZ=UTC \
        PORT=3000 \
        NODE_ENV=production
    
    # Install Chrome manually
    RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
        apt install -y ./google-chrome-stable_current_amd64.deb && \
        rm google-chrome-stable_current_amd64.deb
    
    COPY --chown=node:node --from=build /app/.npmrc /app/package.json /app/pnpm-lock.yaml ./ 
    RUN pnpm install --prod --frozen-lockfile
    
    COPY --chown=node:node --from=build /app/dist ./dist
    COPY --chown=node:node --from=build /app/tools/prisma ./tools/prisma
    RUN pnpm run prisma:generate
    
    EXPOSE 3000
    
    CMD [ "dumb-init", "pnpm", "run", "start" ]
    