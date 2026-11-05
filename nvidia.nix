{config, pkgs, ...}:

{
  targets.genericLinux.gpu.nvidia = {
    enable = true;
    version = "595.104.02";
    sha256 = "sha256-5CHCAuTHn1jDx/MWG75xRU67PYiTb4ggWg4yfNBMWco=";
  };
}
