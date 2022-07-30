# rtpproxy-docker

Pragmatic docker image for the RTPproxy server.

```shell
git submodule update --init --recursive
```

```shell
docker build --target rtpproxy --tag rtpproxy .
```

```shell
docker run -ti \
  -v /run/user/${UID}/rtpproxy:/var/run/rtpproxy \
  -- rtpproxy:latest
```