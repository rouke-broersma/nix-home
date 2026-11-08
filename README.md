# Home Manager configuration

## Shell and prompt

Interactive Bash starts Zsh when it is available. This does not change the
account's login shell and only applies when Bash is the initial shell.

Powerlevel10k is managed from [`.p10k.zsh`](./.p10k.zsh). Edit that file and
apply Home Manager changes to update the prompt. The managed `~/.p10k.zsh`
is a Nix store link, so `p10k configure` cannot reliably update it in place.
If you use the wizard, save its generated configuration separately and copy
the desired changes into this repository.

WSL detection in [`home.nix`](./home.nix) uses `WSL_DISTRO_NAME` from the
evaluation environment. Pure or remote evaluation, or an environment that
does not pass this variable to Nix, may not detect the target host correctly.

## Rootless Docker

The Docker user service is managed by Home Manager but is not automatically
started. Use `start-docker` and `stop-docker` to control it. Inspect
`systemctl --user status docker.service` and
`journalctl --user -u docker.service` when troubleshooting.

On a non-NixOS host, rootless Docker requires user namespaces, host-provided
`newuidmap` and `newgidmap`, and at least 65,536 subordinate UIDs and GIDs
assigned to the user. These host settings are not managed by this
configuration. See the [Docker rootless prerequisites](https://docs.docker.com/engine/security/rootless/#prerequisites).
The user systemd manager and `XDG_RUNTIME_DIR` must also be available.

The Docker client uses the socket in `XDG_RUNTIME_DIR` through `DOCKER_HOST`.
This overrides normal Docker context selection; unset `DOCKER_HOST` in a shell
when you want to use another context.

An existing unmanaged `~/.config/systemd/user/docker.service` can conflict
with Home Manager's managed service. Preserve or move the existing file before
switching, and stop any previously started rootless daemon before starting the
new service. Check whether an older service was enabled for automatic startup
and disable that separately if necessary.

## Git signing

Git commits are signed using SSH. The public key configured in
[`git.nix`](./git.nix) and the corresponding private key or signing agent
must be available on each host. On WSL, the shell initializes the Windows
SSH-agent bridge once per interactive Zsh session.
