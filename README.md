# Alpine Linux Base Image with S6-Overlay

![https://www.augustash.com](https://augustash.s3.amazonaws.com/logos/ash-inline-color-500.png)

**This base container is not currently aimed at public consumption. It exists as a starting point for August Ash containers.**

## Versions

- `1.0.0`, `latest` [(Dockerfile)](https://github.com/augustash/docker-baseimage-alpine/blob/v1.0.0/Dockerfile)

[See VERSIONS.md for image contents.](https://github.com/augustash/docker-baseimage-alpine/blob/master/VERSIONS.md)

## Usage

To build the Docker image, clone the repository and from within the project directory run:

```bash
docker-compose build
```

### Environment Variables

The following variables can be set and will change how the container behaves. You can use the `-e` flag, an environment file, or your Docker Compose file to set your preferred values. The default values are shown:

- `PUID=501`
- `PGID=1000`

## Push the Image

This project is not an automated build within [Docker Hub](https://hub.docker.com/u/ashbase/). Because other containers are based on this one, we do not want accidental errors being automatically pushed out.

After making changes, create a new tagged build from within the project directory:

```bash
docker build -t ashbase/alpine:<tag> ./
```

Push the new tagged image:

```bash
docker push ashbase/alpine:<tag>
```

## Inspiration

- [linuxserver](https://github.com/linuxserver/)
- [just-containers](https://github.com/just-containers/)
