{config, pkgs, ...}:

{
  targets.genericLinux.gpu.nvidia = {
    enable = true;
    version = "595.104.02";
    sha256 = "sha256-jY65AB4FqaimY9PV0wT+tk7yhE7hhczf2VJ4aCD0bhs=";
  };
}
