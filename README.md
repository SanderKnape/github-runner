# Github self-hosted runner Dockerfile and Kubernetes configuration
This repository contains a Dockerfile that builds a Docker image suitable for running a [self-hosted GitHub runner](https://help.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners). A Kubernetes Deployment file is also included that you can use to deploy this container to your Kubernetes cluster.

You can build this image yourself, or use the Docker image from the [Docker Hub](https://hub.docker.com/repository/docker/sanderknape/github-runner/general).

More information can be found in my blog post: [Running self-hosted GitHub Actions runners in your Kubernetes cluster
](https://sanderknape.com/2020/03/self-hosted-github-actions-runner-kubernetes/)
