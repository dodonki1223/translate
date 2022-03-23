#!/bin/sh

DYNAMO_ENDPOINT=http://offline:${DYNAMODB_LOCAL_PORT:-8000} yarn dynamodb-admin
