FROM lsiobase/alpine:3.16

LABEL maintainer="Peppershade <admin@peppershade.nl>"
LABEL description="Dockerfile to build an image of D-Zone which is to be accessed with a reverse proxy like NGINX"

WORKDIR /app/d-zone

# Clone project files
RUN apk add --no-cache git npm nginx
RUN mkdir -p /app/d-zone
RUN git clone -b master https://github.com/d-zone-org/d-zone.git /app/d-zone

# Install project
RUN cd /app/d-zone
COPY root/ /
RUN npm install --no-optional
RUN npm run-script build
RUN apk del --purge git
RUN rm -rf /root/.cache /tmp/*
RUN rm /app/d-zone/socket-config.json
RUN rsync -r --delete --exclude 'web/script/' /app/d-zone/web/ /var/www/html/

# Communicate ports and volumes to be used
EXPOSE 3000
EXPOSE 80

VOLUME /config
