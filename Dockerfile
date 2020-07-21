FROM debian:buster-slim

ENV RUNNER_NAME "runner"
ENV GITHUB_PAT ""
ENV GITHUB_OWNER ""
ENV GITHUB_REPOSITORY ""
ENV RUNNER_WORKDIR "_work"
ENV RUNNER_LABELS "self-hosted"

RUN apt-get update \
    && apt-get install -y \
        curl \
        sudo \
        git \
        net-tools \
        jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m github \
    && usermod -aG sudo github \
    && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER github
WORKDIR /home/github

RUN runver=$(curl --silent https://api.github.com/repos/actions/runner/releases/latest | grep '"tag_name":' | cut -d'"' -f4|sed 's/^.//') && echo $runver && curl -Ls https://github.com/actions/runner/releases/download/v$runver/actions-runner-linux-x64-$runver.tar.gz | tar xz \
    && sudo ./bin/installdependencies.sh
#RUN runver="2.267.1" && echo $runver && curl -Ls https://github.com/actions/runner/releases/download/v$runver/actions-runner-linux-x64-$runver.tar.gz | tar xz \
#    && sudo ./bin/installdependencies.sh

COPY --chown=github:github entrypoint.sh ./entrypoint.sh
RUN sudo chmod u+x ./entrypoint.sh

ENTRYPOINT ["/home/github/entrypoint.sh"]
