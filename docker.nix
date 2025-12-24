{pkgs, ...}: {
  home.packages = [
    #pkgs.colima # container runtime
    #pkgs.docker-client # docker cli
    (pkgs.writeShellScriptBin "dive" ''
      # https://github.com/wagoodman/dive/issues/408#issuecomment-1328143138
      export DOCKER_HOST=$(docker context inspect --format='{{.Endpoints.docker.Host}}')
      exec ${pkgs.dive}/bin/dive "$@"
    '')

    (pkgs.writeScriptBin "docker-killimg" ''
      #!/usr/bin/env bash

      set -euo pipefail

      if [ $# -lt 1 ]; then
        echo "Usage: $(basename $0) <image-name-substring>"
        exit 1
      fi

      docker ps --format json |  ${pkgs.jq}/bin/jq -r --arg name "$1" 'select(.Image | index($name)) | .ID' | xargs -r docker kill
    '')
  ];
}
