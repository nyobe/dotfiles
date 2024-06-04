{
  pkgs,
  config,
  ...
}: {
  programs.kakoune = {
    enable = true;
    defaultEditor = true;
    config = {
      showMatching = true;
      wrapLines.enable = true;
      keyMappings = [
        {
          mode = "normal";
          key = "<esc>";
          effect = ";,";
          docstring = "clear selections";
        }
        {
          mode = "user";
          key = "<space>";
          effect = ";,";
          docstring = "clear selections";
        }
        {
          mode = "user";
          key = "/";
          effect = ":comment-line<ret>";
          docstring = "comment lines";
        }
        {
          mode = "user";
          key = "y";
          effect = "<a-|>pbcopy<ret>";
          docstring = "copy to clipboard";
        }
      ];
    };
  };

  # programs.vscode.enable = true;
  home.sessionPath = [
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  ];
}
