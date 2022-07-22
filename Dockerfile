FROM lsiobase/alpine:3.16

LABEL maintainer="Griefed <griefed@griefed.de>"
LABEL description="Dockerfile to build an image of D-Zone which is to be accessed with a reverse proxy like NGINX"

# Install dependencies, download app, build app, remove unneeded stuff
RUN apk add --no-cache git npm
RUN mkdir -p /app/d-zone
RUN git clone -b master https://github.com/d-zone-org/d-zone.git /app/d-zone
RUN cd /app/d-zone
RUN npm install --no-optional
RUN npm run-script build
RUN apk del --purge git
RUN rm -rf /root/.cache /tmp/*

# Copy local files
COPY root/ /

# Communicate ports and volumes to be used
EXPOSE 3000

VOLUME /config
