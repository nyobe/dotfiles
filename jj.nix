{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.jujutsu = {
    enable = true;
    # https://jj-vcs.github.io/jj/latest/config-schema.json
    settings = {
      user.name = lib.mkDefault "Claire Gaestel";
      user.email = lib.mkDefault "213631+nyobe@users.noreply.github.com";
      ui.default-command = "log";
      snapshot.auto-track = "none()"; # worth it or not?
      git.auto-local-bookmark = false;
      git.private-commits = "master..bookmarks(exact:scratch) | bookmarks(exact:wip)::"; # not the scratch branch, and not anything on top of wip
      aliases = {
        tug = ["bookmark" "move" "--from" "heads(::@- & bookmarks())" "--to" "@-"];
      };
    };
  };

  programs.fish.functions = {
    jj-wip-apply = {
      wraps = "jj rebase -d";
      description = "apply a rev to the wip megamerge";
      argumentNames = ["rev"];
      body = ''jj rebase -s wip -d $rev -d "all:wip-"'';
    };
    jj-wip-unapply = {
      wraps = "jj rebase -d";
      description = "unapply a rev from the wip megamerge";
      argumentNames = ["rev"];
      body = ''jj rebase -s wip -d "all:wip- ~ $rev"'';
    };
    jj-wip-status = {
      description = "show what branches are in the wip megamerge";
      body = ''
          jj log -r 'wip-' --template '
            separate(" ",
                coalesce(bookmarks.join(" + "),  "(" ++ change_id.short() ++ ")"),
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
      body = ''jj rebase -s "all:roots($rev..wip)" -d $rev'';
    };
    jj-wip-move = {
      wraps = "jj bookmark move";
      description = "move wip changes into a merged branch as new commit";
      argumentNames = ["target_branch"];
      body = ''
        jj new
        jj rebase -r @- --insert-after $target_branch
        jj bookmark move $target_branch --to $target_branch+
      '';
    };
    jj-wip-new = {
      description = "create a new feature branch and add it to the megamerge";
      argumentNames = ["branch_name"];
      body = ''
        jj new -A master -B wip
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
    jjwr = "jj-wip-rebase master";
    jjwl = "jj log -r master..wip";
    jjwm = "jj-wip-move";
    jjwa = "jj-wip-new";
    jjwn = "jj-wip-new";
  };
}
