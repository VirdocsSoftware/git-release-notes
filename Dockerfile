FROM ubuntu:16.04
SHELL ["/bin/bash", "-c"]

ENV NVM_DIR $HOME/.nvm
ENV NODE_VERSION 6.9.4
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN apt-get update && \
    apt-get install -y \
    git \
    wget \
    unzip && \
    wget https://s3.amazonaws.com/redshelf-apt-repo/google-chrome-stable_65.0.3325.162-1_amd64.deb -O /tmp/google-chrome-stable.deb && \
    dpkg -i /tmp/google-chrome-stable.deb || apt-get install -y -f && \
    wget https://chromedriver.storage.googleapis.com/2.36/chromedriver_linux64.zip  -O /tmp/chromedriver.zip && \
    unzip -o /tmp/chromedriver.zip -d /usr/local/bin/ && chmod 755 /usr/local/bin/chromedriver && \
    wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash && \
    source $NVM_DIR/nvm.sh && \
    nvm install v6.9.4 && \
    nvm alias default v6.9.4 && \
    npm i -g codecov

COPY package.json /srv/app/package.json

WORKDIR /srv/app/

ARG NPM_TOKEN
RUN NPM_TOKEN=$NPM_TOKEN npm i

COPY . /srv/app

