FROM node:17.0.0-alpine

RUN yarn add dynamodb-admin

COPY .docker/dynamodb-admin/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
