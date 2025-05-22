function select_docker_container
  if not string match -q "docker*" (commandline)
    return 1
  end

  echo (docker ps -a | peco --initial-index 1 | awk '{print $1}' | tr "\r" " ")
end

abbr -a container --position anywhere -f select_docker_container
abbr -a image --position anywhere -f select_docker_image
