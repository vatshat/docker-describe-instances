FROM python:3.6-alpine

# https://vsupalov.com/docker-build-pass-environment-variables/
# https://blog.bekt.net/p/docker-aws-credentials/

# ARG access-key-id
# ARG secret-access-key
# ENV AWS_ACCESS_KEY_ID=$access-key-id
# ENV AWS_SECRET_ACCESS_KEY=$secret-access-key

# https://michaelheap.com/extract-substring-values-jq
# instance_role=curl -s 169.254.169.254/latest/meta-data/iam/info | jq ".InstanceProfileArn" | sed -e 's/^"//' -e 's/"$//' | awk -F'/' '{print $2}'

RUN apk add --no-cache curl
RUN apk add --no-cache jq
RUN curl -o /usr/local/bin/jq http://stedolan.github.io/jq/download/linux64/jq && \
  chmod +x /usr/local/bin/jq

RUN instance_role=curl -s 169.254.169.254/latest/meta-data/iam/info | jq -r '. | map(.)[2] | split("/")[1]'
RUN export AWS_ACCESS_KEY_ID=$(curl -s 169.254.169.254/latest/meta-data/iam/security-credentials/"$instance_role" | jq --raw-output ".AccessKeyId")
RUN export AWS_SECRET_ACCESS_KEY=$(curl -s 169.254.169.254/latest/meta-data/iam/security-credentials/"$instance_role" | jq --raw-output ".SecretAccessKey")

ENV AWS_DEFAULT_REGION=eu-west-1

COPY requirements.txt .
RUN pip install -r ./requirements.txt

CMD gunicorn app:app -b :8000 --name app --log-level=debug --log-file=-
