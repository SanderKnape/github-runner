# Github self-hosted runner Dockerfile and Kubernetes configuration

[![awesome-runners](https://img.shields.io/badge/listed%20on-awesome--runners-blue.svg)](https://github.com/jonico/awesome-runners)

This repository contains a Dockerfile that builds a Docker image suitable for running a [self-hosted GitHub runner](https://sanderknape.com/2020/03/self-hosted-github-actions-runner-kubernetes/). A Kubernetes Deployment file is also included that you can use as an example on how to deploy this container to a Kubernetes cluster.

You can build this image yourself, or use the Docker image from the [Docker Hub](https://hub.docker.com/repository/docker/sanderknape/github-runner/general).

## Building the container

`docker build -t github-runner .`

## Features

* Repository runners
* Organizational runners
* Labels
* Graceful shutdown
* Support for installing additional debian packages
* Auto-update after the release of a new version

## Examples

Register a runner to a repository.

```sh
docker run --name github-runner \
     -e GITHUB_OWNER=username-or-organization \
     -e GITHUB_REPOSITORY=my-repository \
     -e GITHUB_PAT=[PAT] \
     sanderknape/github-runner
```

Register a runner with github token.

```sh
docker run --name github-runner \
     -e GITHUB_OWNER=username-or-organization \
     -e GITHUB_REPOSITORY=my-repository \
     -e GITHUB_TOKEN=[github.token] \
     sanderknape/github-runner
```

Create an organization-wide runner.

```sh
docker run --name github-runner \
    -e GITHUB_OWNER=username-or-organization \
    -e GITHUB_PAT=[PAT] \
    sanderknape/github-runner
```

Set labels on the runner.

```sh
docker run --name github-runner \
    -e GITHUB_OWNER=username-or-organization \
    -e GITHUB_REPOSITORY=my-repository \
    -e GITHUB_PAT=[PAT] \
    -e RUNNER_LABELS=comma,separated,labels \
    sanderknape/github-runner
```

Install additional tools on the runner.

```sh
docker run --name github-runner \
    -e GITHUB_OWNER=username-or-organization \
    -e GITHUB_REPOSITORY=my-repository \
    -e GITHUB_PAT=[PAT] \
    -e ADDITIONAL_PACKAGES=firefox-esr,chromium \
    sanderknape/github-runner
```
