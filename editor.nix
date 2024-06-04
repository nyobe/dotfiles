{
  pkgs,
  config,
  ...
}: {
  programs.kakoune = {
    enable = true;
    defaultEditor = true;
  };

  # programs.vscode.enable = true;
  home.sessionPath = [
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  ];
}
