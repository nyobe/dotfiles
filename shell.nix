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
    config = {
      global.hide_env_diff = true;
    };
  };

  programs.fish = {
    enable = true;
    functions = {
      fish_greeting = "";
      mkcd = ''mkdir -p $argv; and cd $argv'';
      scratch = ''mkcd ~/scratch/"$(date +%F)_$(echo $argv)"'';
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
        "$pulumi"
        "$kubernetes"
        "$git_branch"
        "$git_state"
        #"$git_status"
        "$cmd_duration"
        #"$fill"
        "$line_break"
        #"$nix_shell"
        "$python"
        #"$direnv"
        "$character"
      ];

      directory.style = "blue";
      # directory.fish_style_pwd_dir_length = 1;

      character = {
        success_symbol = "[❯](black)";
        error_symbol = "[x](red)";
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

      kubernetes = {
        disabled = false;
        detect_env_vars = ["KUBECONFIG"];
        format = "[$context(/\($namespace\))]($style) ";
      };

      fill = {
        symbol = " ";
      };

      pulumi = {
        format = "[\($username@\)$stack]($style) ";
      };
    };
  };
}
