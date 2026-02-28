{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = [
      pkgs.jjui
  ];
  programs.jujutsu = {
    enable = true;
    # https://jj-vcs.github.io/jj/latest/config-schema.json
    settings = {
      user.name = lib.mkDefault "Claire Gaestel";
      user.email = lib.mkDefault "213631+nyobe@users.noreply.github.com";
      ui.default-command = "log";
      git.auto-local-bookmark = false;
      git.private-commits = "trunk()..bookmarks(exact:scratch) | bookmarks(exact:wip)::"; # not the scratch branch, and not anything on top of wip
      aliases = {
        tug = ["bookmark" "move" "--from" "heads(::@- & bookmarks())" "--to" "latest(::@- ~ empty())"];
        pr = ["util" "exec" "--" "sh" "-c" ''gh pr view $(jj log -r @- --no-graph -T 'local_bookmarks.join(" ")')''];
      };
      revset-aliases = {
        tidy = "empty() & (@:: ~ bookmarks())";
        "tidy(x)" = "empty() & (x:: ~ bookmarks())";
      };
    };
  };

  programs.fish.functions = {
    jj-wip-apply = {
      wraps = "jj rebase -d";
      description = "apply a rev to the wip megamerge";
      argumentNames = ["rev"];
      body = ''
          jj rebase -s wip -d $rev -d wip-

          # make re-applying an updated bookmark work
          jj simplify-parents -s wip --quiet
        '';
    };
    jj-wip-unapply = {
      wraps = "jj rebase -d";
      description = "unapply a rev from the wip megamerge";
      argumentNames = ["rev"];
      body = ''
          # if this is the last commit in the megamerge, just move the wip onto trunk()
          jj rebase -s wip -d "wip- ~ $rev"; or \
          jj rebase -s wip -d 'trunk()'
      '';
    };
    jj-wip-status = {
      description = "show what branches are in the wip megamerge";
      body = ''
          jj log -r 'wip-' --template '
            separate(" ",
                coalesce(bookmarks.join(" + "), working_copies.join(" + "), "(" ++ change_id.short() ++ ")"),
                "-", description.first_line(), "\n",
            )
        ' --no-graph
      '';
    };
    jj-wip-rebase = {
      wraps = "jj rebase -d";
      description = "rebase wip megamerge onto rev";
      argumentNames = ["rev"];
      #body = ''jj rebase -s wip -d "all:wip- ~ $rev" -d $rev'';
      body = ''
        jj rebase -s "roots($rev..wip)" -d $rev
      '';
    };
    jj-wip-move = {
      wraps = "jj bookmark move";
      description = "add a rev (default @-) to the end of a branch. this is useful for moving changes from the top of the wip branch into one of the merged feature branches";
      body = ''
        argparse 'r=' -- $argv
        test -n "$_flag_r"; or set -l _flag_r '@-'
        set -l target_branch $argv[1]
        jj rebase -r $r --insert-after $target_branch
        jj bookmark move $target_branch --to $target_branch+
      '';
    };
    jj-wip-new = {
      description = "create a new feature branch and add it to the megamerge";
      argumentNames = ["branch_name"];
      body = ''
        jj new -A 'trunk()' -B wip
        jj bookmark create $branch_name -r @
        jj new -r wip
        jj-wip-status
      '';
    };
  };
  programs.fish.shellAbbrs = {
    jjw = "jj-wip-apply";
    jjW = "jj-wip-unapply";
    jjws = "jj-wip-status";
    jjwr = "jj-wip-rebase 'trunk()'";
    jjwl = "jj log -r 'trunk()..wip'";
    jjwm = "jj-wip-move";
    jjwa = "jj-wip-new";
    jjwc = "jj log -r 'tidy(wip)'";
    jjwC = "jj abandon 'tidy(wip)'";
    jjwf = "jj workspace update-stale";
    jjwx = "jj rebase -s wip -d 'trunk()'"; # clear the wip
  };
}
