FROM debian:buster-slim

#ARG GH_RUNNER_VERSION="2.272.0"
ARG DOCKER_COMPOSE_VERSION="1.26.2"

ENV RUNNER_NAME "runner"
ENV GITHUB_PAT ""
ENV GITHUB_OWNER ""
ENV GITHUB_REPOSITORY ""
ENV RUNNER_WORKDIR "_work"
ENV RUNNER_LABELS "self-hosted"
ENV RUNNER_ALLOW_RUNASROOT=true

# Labels
LABEL maintainer="github.com/karthick-kk" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.name="karthickk/github-runner" \
    org.label-schema.description="Dockerized GitHub Actions runner." \
    org.label-schema.url="https://github.com/karthick-kk/github-runner" \
    org.label-schema.vcs-url="https://github.com/karthick-kk/github-runner" \
    org.label-schema.vendor="Karthick K" \
    org.label-schema.docker.cmd="docker run -it karthickk/github-runner:latest"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y \
        iputils-ping \
        curl \
        sudo \
        git \
        net-tools \
        jq \
    && useradd -m github \
    && usermod -aG sudo github \
    && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Docker CLI
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

# Install Docker-Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

RUN usermod -aG docker github

RUN GH_RUNNER_VERSION=${GH_RUNNER_VERSION:-$(curl --silent "https://api.github.com/repos/actions/runner/releases/latest" | grep tag_name | sed -E 's/.*"v([^"]+)".*/\1/')} \
    && curl -L -O https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz \
    && tar -zxf actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz \
    && rm -f actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz \
    && ./bin/installdependencies.sh \
    && chown -R root: /home/github \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && apt-get clean

COPY entrypoint.sh /home/github/entrypoint.sh
RUN chmod +x /home/github/entrypoint.sh

ENTRYPOINT ["/home/github/entrypoint.sh"]
