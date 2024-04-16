{pkgs, ...}: {
  home.packages = [
    pkgs.colima # container runtime
    pkgs.docker-client # docker cli
    (pkgs.writeShellScriptBin "dive" ''
      # https://github.com/wagoodman/dive/issues/408#issuecomment-1328143138
      export DOCKER_HOST=$(docker context inspect --format='{{.Endpoints.docker.Host}}')
      exec ${pkgs.dive}/bin/dive "$@"
    '')
  ];
}
