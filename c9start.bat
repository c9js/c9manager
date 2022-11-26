docker run -itv "//var/run/docker.sock:/var/run/docker.sock" -e "CD=%CD%" --privileged --rm c9js/c9start:1.0.39
