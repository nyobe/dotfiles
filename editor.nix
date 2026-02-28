{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    (pkgs.writeShellScriptBin "idea" ''
      open -na "IntelliJ IDEA.app" --args "$@"
    '')
  ];

  programs.kakoune = {
    enable = true;
    defaultEditor = true;
    config = {
      #   colorSchemePackage = pkgs.fetchFromGitHub {
      # owner = "jethrokuan";
      # repo = "z";
      # rev = "ddeb28a7b6a1f0ec6dae40c636e5ca4908ad160a";
      # sha256 = "0c5i7sdrsp0q3vbziqzdyqn4fmp235ax4mn4zslrswvn8g3fvdyh";
      # };

      #colorScheme = "plain";
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
  # https://github.com/mawww/kakoune/wiki/Running-commands-at-startup#the-autoload-directory
  xdg.configFile."kak/autoload/standard-library".source = "${pkgs.kakoune-unwrapped}/share/kak/autoload";

  # programs.vscode.enable = true;
  home.sessionPath = [
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  ];

  # Ghostty
  home.file = {
    ".config/ghostty/config".text = ''
      theme = Terminal Basic
      keybind = shift+enter=text:\x1b\r
      auto-update-channel = tip
    '';
  };
}
