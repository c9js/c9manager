docker run -itv"//var/run/docker.sock:/var/run/docker.sock" -e"IMAGE_DEV=c9start" -e "CD=%CD%" --privileged --rm c9start
