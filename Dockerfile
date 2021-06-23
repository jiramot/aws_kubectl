FROM alpine:latest

ENV AWS_DEFAULT_REGION=ap-southeast-1

ADD https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl /usr/local/bin/kubectl

RUN set -x && \
    apk add --update --no-cache curl ca-certificates bash python3 py-pip jq && \
    chmod +x /usr/local/bin/kubectl && \
    pip install --upgrade awscli && \
    aws --version && \
    ln -s /usr/bin/aws /usr/local/bin/aws && \
    kubectl version --client

CMD ["bash"]
