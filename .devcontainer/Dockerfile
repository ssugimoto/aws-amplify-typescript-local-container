FROM mcr.microsoft.com/vscode/devcontainers/typescript-node:0-18

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install --no-install-recommends java-common zip \
  && wget https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.deb \
  && dpkg --install amazon-corretto-8-x64-linux-jdk.deb \
  && wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
  && unzip awscli-exe-linux-x86_64.zip \
  && ./aws/install \
  # Clean up
  && rm -f awscli-exe-linux-x86_64.zip \
  && rm -f amazon-corretto-8-x64-linux-jdk.deb \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog

# docker imageの方で既にnvmは入っている
# rootからnodeユーザーになっている
# ENV NVM_DIR /usr/local/share/nvm
# ENV NODE_VERSION 16.15.1
#
# Install nvm with node and npm
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash \
#   && . $NVM_DIR/nvm.sh \
#   && nvm install $NODE_VERSION \
#   && nvm alias default $NODE_VERSION \
#   && nvm use default
# 

# 自分が使いたいnodeバージョンをインストール,  use pre Installed nvm. install use node veresion.
# RUN su node -c "source /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} && nvm alias default $NODE_VERSION && nvm use default"

# voltaは自前でインストールする
RUN su node -c "curl -o- https://get.volta.sh | bash "

RUN su node -c "npm install --global @aws-amplify/cli@12.3.0 --unsafe-perm=true"
WORKDIR /workspaces

# nodeユーザー向け
RUN chown node:node /workspaces