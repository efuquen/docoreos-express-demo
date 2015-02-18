FROM quay.io/somespider/nodejs-busybox

# Install npm dependencies
ADD ./package.json /app/package.json
RUN cd /app && npm install --quiet

ADD      ./src /app/src
WORKDIR  /app/src

EXPOSE 3000

CMD ["node", "server.js"]
