FROM python:3.6-alpine

# https://vsupalov.com/docker-build-pass-environment-variables/
# https://blog.bekt.net/p/docker-aws-credentials/

ARG access_key_id_key-id
ARG secret_access_key
ARG session_token
ARG aws_default_region
ENV AWS_ACCESS_KEY_ID=$access_key_id
ENV AWS_SECRET_ACCESS_KEY=$secret_access_key
ENV AWS_DEFAULT_REGION=$aws_default_region
ENV AWS_SESSION_TOKEN=$session_token

COPY requirements.txt .
RUN pip install -r ./requirements.txt
