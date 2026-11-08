# ~/.config/home-manager/docker.nix
{ pkgs, ... }:

let
  dockerPkg = pkgs.docker;
  startDocker = pkgs.writeShellScriptBin "start-docker" ''
    if systemctl --user start docker.service; then
      echo "Rootless Docker started."
    else
      echo "Failed to start rootless Docker; inspect the docker.service user journal." >&2
      exit 1
    fi
  '';
  stopDocker = pkgs.writeShellScriptBin "stop-docker" ''
    if systemctl --user stop docker.service; then
      echo "Rootless Docker stopped."
    else
      echo "Failed to stop rootless Docker; inspect the docker.service user journal." >&2
      exit 1
    fi
  '';
in
{
  home.packages = with pkgs; [
    docker
    docker-compose
    docker-buildx
    slirp4netns
    fuse-overlayfs
    startDocker
    stopDocker
  ];

  home.sessionVariables.DOCKER_HOST = "unix://\${XDG_RUNTIME_DIR:-}/docker.sock";

  home.sessionVariablesExtra = ''
    if [ -z "''${XDG_RUNTIME_DIR:-}" ]; then
      echo "Rootless Docker requires XDG_RUNTIME_DIR; DOCKER_HOST is not usable in this session." >&2
    fi
  '';

  systemd.user.services.docker = {
    Unit = {
      Description = "Docker Application Container Engine (Rootless)";
      Documentation = [ "https://docs.docker.com/engine/security/rootless/" ];
    };
    Service = {
      Environment = "PATH=${dockerPkg}/bin:/run/wrappers/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
      ExecStart = "${dockerPkg}/bin/dockerd-rootless";
      Type = "notify";
      NotifyAccess = "all";
      TimeoutStartSec = 120;
      Restart = "on-failure";
      RestartSec = 2;
      LimitNOFILE = "infinity";
      LimitNPROC = "infinity";
      LimitCORE = "infinity";
      TasksMax = "infinity";
      Delegate = true;
      KillMode = "mixed";
    };
  };
}
