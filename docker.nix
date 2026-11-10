# ~/.config/home-manager/docker.nix
{ pkgs, ... }:

let
  dockerPkg = pkgs.docker;
  
  startDocker = pkgs.writeShellScriptBin "start-docker" ''
    if systemctl --user start docker.service; then
      echo "Rootless Docker started."
    else
      echo "Failed to start rootless Docker; inspect with: journalctl --user -u docker.service -e" >&2
      exit 1
    fi
  '';
  
  stopDocker = pkgs.writeShellScriptBin "stop-docker" ''
    if systemctl --user stop docker.service; then
      echo "Rootless Docker stopped."
    else
      echo "Failed to stop rootless Docker; inspect with: journalctl --user -u docker.service -e" >&2
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

  # Socket path environment variable for rootless daemon
  home.sessionVariables = {
    DOCKER_HOST = "unix:///run/user/1000/docker.sock";
  };

  systemd.user.services.docker = {
    Unit = {
      Description = "Docker Application Container Engine (Rootless)";
      Documentation = [ "https://docs.docker.com/engine/security/rootless/" ];
    };
    Service = {
      Environment = "PATH=${dockerPkg}/bin:/run/wrappers/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
      ExecStart = "${dockerPkg}/bin/dockerd-rootless --exec-opt native.cgroupdriver=cgroupfs";
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
