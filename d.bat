docker run -itv "//var/run/docker.sock:/var/run/docker.sock" -e "CD=%CD%" --privileged --rm alpine:latest
