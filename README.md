# rtpproxy-docker

Pragmatic docker image for the RTPproxy server.

## Quick Start guide

```shell
git clone --recurse-submodules "git@github.com:jfsmig/rtpproxy-docker.git"
cd rtpproxy-docker
```

```shell
git clone "git@github.com:jfsmig/rtpproxy-docker.git"
cd rtpproxy-docker
git submodule update --init --recursive
```

```shell
docker build --target rtpproxy --tag rtpproxy .

docker run -ti \
  -v /run/user/${UID}/rtpproxy:/var/run/rtpproxy \
  -- rtpproxy:latest
```

## RTPproxy commands cheat sheet

Because it's hard to find a documentation outside of the code of RTPproxy,
here's an extract from [./rtpproxy/src/rtpp_command_parse.c](https://github.com/jfsmig/rtpproxy/blob/master/src/rtpp_command_parse.c)

| Action               | Syntax                                                                                |
|----------------------|---------------------------------------------------------------------------------------|
| Create / Update      | `U[opts] callid remote_ip remote_port from_tag [to_tag] [notify_socket notify_tag]`   |
| Lookup               | `L[opts] callid remote_ip remote_port from_tag [to_tag]`                              |
| Delete               | `D[w] callid from_tag [to_tag]`                                                       |
| Play                 | `P[n] callid pname codecs from_tag [to_tag]`                                          |
| Record               | `R[s] call_id from_tag [to_tag]`                                                      |
| Copy                 | `C[-xxx-] call_id -XXX- from_tag [to_tag]`                                            |
| Stop / No Play       | `S call_id from_tag [to_tag]`                                                         |
| No Record            | `N[a] call_id from_tag [to_tag]`                                                      |
| Query                | `Q[v] call_id from_tag [to_tag [stat_name1 ...[stat_nameN]]]`                         |
| Delete All / Expunge | `X`                                                                                   |
| Stats / Get Stats    | `G[v] [stat_name1 [stat_name2 [stat_name3 ...[stat_nameN]]]]`                         |
| Feature Check        | `VF feature_num`                                                                      |
| Version              | `V`                                                                                   |
| Info                 | `I[b]`                                                                                |
