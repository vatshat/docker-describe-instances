FROM python:3.6-alpine

# https://vsupalov.com/docker-build-pass-environment-variables/
# https://blog.bekt.net/p/docker-aws-credentials/

ARG access-key-id
ARG secret-access-key
ENV AWS_ACCESS_KEY_ID=$access-key-id
ENV AWS_SECRET_ACCESS_KEY=$secret-access-key
ENV AWS_DEFAULT_REGION=$aws_default_region

COPY requirements.txt .
RUN pip install -r ./requirements.txt
