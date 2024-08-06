FROM alpine:3.19

ARG OPA_VERSION=v0.3.3
ARG GIT_CONFIG_USER_NAME
ARG GIT_CONFIG_USER_EMAIL

RUN apk update && apk add --no-cache \
    curl \
    make \
    bash \
    procps \
    npm \
    gcc \
    g++ \
    rsync \
    docker

# The following configuration is based on the contents described in https://opaonaws.io/docs/getting-started/deploy-the-platform.

WORKDIR /app

# Install Node.js, Yarn, AWS CLI, jq, Git and Python3
RUN apk add --no-cache \
    nodejs~=20 \
    yarn \
    aws-cli \
    jq \
    git \
    python3

RUN git config --global user.name "$GIT_CONFIG_USER_NAME" && \
    git config --global user.email "$GIT_CONFIG_USER_EMAIL"

# Install AWS CDK
RUN yarn global add aws-cdk

# Clone the OPA on AWS repository
RUN git clone https://github.com/awslabs/app-development-for-backstage-io-on-aws.git -b $OPA_VERSION --depth 1
WORKDIR /app/app-development-for-backstage-io-on-aws

# NOTE: Although this was fixed in https://github.com/awslabs/app-development-for-backstage-io-on-aws/pull/43, the change was reverted in a subsequent release. Therefore, I am using `sed` to modify it.
RUN sed -i.bak "s/\[\[ ! -z \"\$IS_DEFENDER\" \]\]/command -v git-defender/" ./build-script/gitlab-tools.sh && \
    sed -i.bak "s/IS_DEFENDER=\$(type \"git-defender\" 2>\/dev\/null)//" ./build-script/gitlab-tools.sh

# Copy the .config file
COPY .config ./config/.env

# Run the make command
CMD [ "make", "help" ]
