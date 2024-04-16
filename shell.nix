{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.autojump.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fish = {
    enable = true;
    functions = {
      fish_greeting = "";
      mkcd = "mkdir -p $argv; and cd $argv";
    };
  };

  # make the zsh login shell immediately invoke fish - easier than dealing with /etc/shells
  home.file.".zlogin".text = ''
    # immediately invoke fish, unless shell was invoked with the -c option.
    # (prevents breaking intellij / vscode environment detection, see https://superuser.com/a/1806104)
      if [[ -z "$ZSH_EXECUTION_STRING" ]]; then
        exec fish
      fi
  '';

  programs.starship = {
    enable = true;

    # adapted from `starship preset pure-preset`
    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$cmd_duration"
        "$line_break"
        "$python"
        "$character"
      ];

      directory.style = "blue";

      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };

      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };

      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };

      git_state = {
        format = "\([$state( $progress_current/$progress_total)]($style)\) ";
        style = "bright-black";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };

      python = {
        format = "[$virtualenv]($style) ";
        style = "bright-black";
      };
    };
  };
}
