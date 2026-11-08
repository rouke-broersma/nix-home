# ~/.config/home-manager/docker.nix
{ pkgs, lib, ... }:

let
  dockerPkg = pkgs.docker;
in
{
  home.packages = with pkgs; [
    docker          # CLI, dockerd engine, and dockerd-rootless
    docker-compose  # Compose v2 plugin
    docker-buildx   # Buildx plugin
    slirp4netns     # User-space networking engine
    fuse-overlayfs  # User-space overlay storage driver
  ];

  # Socket path environment variable for rootless daemon
  home.sessionVariables = {
    DOCKER_HOST = "unix:///run/user/1000/docker.sock";
  };

  # Lifecycle control aliases pointing directly to the binaries provided by pkgs.docker
  home.shellAliases = {
    start-docker = "nohup ${dockerPkg}/bin/dockerd-rootless >/dev/null 2>&1 & echo 'Docker daemon started in background.'";
    stop-docker = "pkill -f dockerd-rootless || echo 'Docker daemon stopped.'";
  };

  # Activation hook to run setup tool on initial install
  home.activation.setupRootlessDocker = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -x "${dockerPkg}/bin/dockerd-rootless-setuptool.sh" ] && [ ! -d "$HOME/.local/share/docker" ]; then
      $DRY_RUN_CMD ${dockerPkg}/bin/dockerd-rootless-setuptool.sh install
    fi
  '';
}
