# 使用する image のバージョン情報を docker-compose.yml から取得する
ARG NODE_VERSION
ARG PYTHON_VERSION
ARG UBUNTU_VERSION

# Node.js, Python はマルチステージングビルドで Node.js, Python だけ ubuntu の image にコピーさせる
FROM node:$NODE_VERSION as node
FROM python:$PYTHON_VERSION-buster as python
FROM ubuntu:$UBUNTU_VERSION

# Node.js を使えるようにするため Node.js の Image から Node.js だけ ubuntu へ移動させる
COPY --from=node /usr/local/bin /usr/local/bin
COPY --from=node /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/npm
COPY --from=node /opt/yarn* /opt/yarn
RUN ln -fs /opt/yarn/bin/yarn /usr/local/bin/yarn && \
    ln -fs /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg

# Python を使えるようにするため Python の Image から Python だけ ubuntu へ移動させる
COPY --from=python /usr/local/bin /usr/local/bin
COPY --from=python /usr/local/lib /usr/local/lib
COPY --from=python /usr/local/include /usr/local/include
COPY --from=python /lib/aarch64-linux-gnu/libexpat.so.1 /usr/lib/aarch64-linux-gnu/libexpat.so.1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# 欲しいツールは .docker/Aptfile ファイルに記載しておくことで自動でインストールされる
COPY .docker/offline/Aptfile /tmp/Aptfile

# hadolint ignore=DL3008, SC2002
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    curl \
    unzip \
    less \
    ca-certificates \
    default-jre \
    $(cat /tmp/Aptfile | xargs) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

# AWS CLI を公式のドキュメントのARM版のインストール方法に則って行う
#   https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/getting-started-install.html
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "/tmp/awscliv2.zip" \
    && unzip /tmp/awscliv2.zip -d /tmp \
    && /tmp/aws/install \
    && rm -rf /tmp/awscliv2.zip /tmp/aws

# バージョンを docker-compose.yml から取得し Serverless Framework をグローバルにインストールする
ARG SEVERLESS_FRAMEWORK_VERSION
RUN npm install -g serverless@$SEVERLESS_FRAMEWORK_VERSION

WORKDIR /app

COPY . .

# Node.js と Python の依存関係をインストールする
RUN .docker/bin/install_dependencies
