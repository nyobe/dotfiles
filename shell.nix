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

      bak = ''set -l f (path normalize $argv); and mv -i $f $f.bak'';
      unbak = ''set -l f (path normalize $argv); and test (path extension $f) = "bak"; and mv -i $f (path change-extension "" $f)'';
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
        # what parts of this are actually useful?
      format = lib.concatStrings [
          # these will only show up in ssh, right?
        "$username"
        "$hostname"
        "$directory"
        # my pws utility makes pulumi login/stack selection tied to the cwd, (and the starship plugin is not aware of PULUMI_OPTION_STACK so its misleading).
        "$pulumi"
        # similar to pulumi, using direnv to tie the selected kubecontext / ns to the cwd is less error prone. maybe the main thing that is useful is an indicator that one is active? k9s doesn't even respect the selected namespace :/
        "$kubernetes"
        # git state is useless with jj
        # there is a jj-starship plugin, but is that really that useful either? I tend to orient myself using jj log
        "$git_branch"
        "$git_state"
        #"$git_status"
        "$cmd_duration"
        #"$fill"
        "$line_break"
        #"$nix_shell"
        # toolchains should all be brought in via devshell of some kind: devbox or mise. venv should either be implicit (uv/poetry) or activated via direnv. 
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
