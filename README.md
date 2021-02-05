# bpxtools
Small Linux container with tools for running demos.

Update your Dockerfile with the versions of Kubernetes kubectl you'd like to support.

The best way to run this is with the docker-compose file, which mounts various directories from your home to assist in connecting to other services. It launches the container which sits idle in the background and then you can exec into it in order to use it as your shell.

```
docker-compose up -d
docker exec -ti bpxtools bash
```

