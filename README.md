[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/bplein/bpxtools?sort=semver)](https://hub.docker.com/repository/docker/bplein/bpxtools/tags?page=1&ordering=last_updated)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bplein/bpxtools/build-image.yml)](https://github.com/bplein/bpxtools/actions/workflows/build-image.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/bplein/bpxtools)](https://hub.docker.com/repository/docker/bplein/bpxtools/general)
# bpxtools
Small Linux container with tools for running demos.

Update your Dockerfile with the versions of Kubernetes kubectl you'd like to support.

The best way to run this is with the docker-compose file, which mounts various directories from your home to assist in connecting to other services. It launches the container which sits idle in the background and then you can exec into it in order to use it as your shell.

```
docker-compose up -d
docker exec -ti bpxtools bash
```

