# Github self-hosted runner Dockerfile and Kubernetes configuration

Add project to awesome-runners list

This repository contains a Dockerfile that builds a Docker image suitable for running a [self-hosted GitHub runner](https://sanderknape.com/2020/03/self-hosted-github-actions-runner-kubernetes/). A Kubernetes Deployment file is also included that you can use as an example on how to deploy this container to a Kubernetes cluster.

You can build this image yourself, or use the Docker image from the [Docker Hub](https://hub.docker.com/repository/docker/sanderknape/github-runner/general).

## Building the container

`docker build -t github-runner .`

## Features

* Repository runners
* Organizational runners
* Labels
* Graceful shutdown
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


