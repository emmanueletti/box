# DOCKER_HOST from the active context — guarded & quiet so a stopped or
# absent Docker doesn't error / set a broken value at every shell start.
# Lives here (not ~/.zshenv) because the subprocess would slow every script.
if (( $+commands[docker] )); then
  export DOCKER_HOST="$(docker context inspect --format '{{.Endpoints.docker.Host}}' 2>/dev/null)"
fi
