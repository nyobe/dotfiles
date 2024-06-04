{
  pkgs,
  config,
  ...
}: {
  programs.kakoune = {
    enable = true;
    defaultEditor = true;
  };
}
