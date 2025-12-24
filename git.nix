{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = [
    pkgs.gh
    pkgs.git-get
  ];

  # programs.fish.functions.git = {
  #   wraps = "git";
  #   body = ''
  #            if test $argv[1] = "push" -a !(command git rev-parse --abbrev-ref @{u} &>/dev/null)
  #                echo "Error: No upstream branch set for $(command git rev-parse --abbrev-ref HEAD)"
  #                echo "Use: git publish"
  #                return 1
  #            end

  #     command git $argv

  #   '';
  # };

  programs.git = {
    enable = true;
    settings.user.name = lib.mkDefault "Claire Gaestel";
    settings.user.email = lib.mkDefault "213631+nyobe@users.noreply.github.com";
    settings = {
      init.defaultBranch = "main";
      push.default = "upstream";
      push.autoSetupRemote = false;
      remote.origin.prune = true;
      rebase.autosquash = true;
      advice.detachedHead = false;

      column.ui = "auto";
      #branch.sort = "-comitterdate";
      # commit.verbose = true;
      rerere.enabled = true;
      rerere.autoupdate = true;
      pull.rebase = true;
      # rebase.autosquash = true;
      rebase.autostash = true;
      rebase.updateRefs = true; # fixup stacked refs automatically
      tag.sort = "version:refname";

      diff.algorithm = "histogram";
      diff.colorMoved = "plain";
      diff.mnemonicPrefix = true;
      diff.renames = true;

      #push.followTags = true; # push tags by default

      # what's the diff vs origin.prune?  origin.prune is specifically for origin.
      fetch.prune = true; # global prune remote tracking branches
      fetch.pruneTags = true; # delete tags
      fetch.all = true; # fetch all remotes, not just origin

      commit.verbose = true; # don't need the alias now

      #merge.conflictstyle = "zdiff3";  # 3 part diff, shows what the conflict looked like prior to change on both sides

      #core.fsmonitor = true;  #maybe just enable on the pulumi repo
      #core.untrackedCache = true;
    };
    ignores = [
      ".DS_Store"
    ];
    settings.alias = {
      root = "rev-parse --show-toplevel";
      main-branch = "!git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4";
      publish = "!git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)";
      unpublish = "!git branch --unset-upstream && git push origin --delete $(git rev-parse --abbrev-ref HEAD)";
      checkout-sync = "!git switch $@ && git submodule update --init --recursive";
    };
  };

  # vs home.shellAliases?
  programs.fish.shellAbbrs = {
    # based on https://github.com/sorin-ionescu/prezto/blob/master/modules/git/alias.zsh
    g = "git";

    # Branch (b)
    gb = "git branch";
    gba = "git checkout -b";
    gbl = "git branch --verbose --sort=-authordate";
    gbx = "git branch --delete";
    gbX = "git branch --delete --force";
    gbm = "git branch --move";
    gbM = "git reset --keep";
    gbc = "git branch --verbose | grep --fixed-strings '[gone]' | awk '{print $1}'";
    gbC = "git branch --verbose | grep --fixed-strings '[gone]' | awk '{print $1}' | xargs git branch --delete --force";
    gbP = "git publish";

    # Commit (c)
    gc = "git commit --verbose";
    gcf = "git commit --amend --no-edit";
    gcF = "git commit --amend";
    gco = "git checkout";
    gcom = "git checkout (git main-branch)";
    gcp = "git cherry-pick --ff";
    gcx = "git reset --soft HEAD^";
    gcX = "git revert";
    gcs = "git show --stat";
    gcd = "git show";
    gcw = "git commit -m 'WIP'";

    # Conflict (C)
    gCl = "git --no-pager diff --name-only --diff-filter=U";
    gCa = "git add (gCl)";
    gCe = "git mergetool (gCl)";
    gCo = "git checkout --ours ";
    gCO = "git checkout --ours (gCl)";
    gCt = "git checkout --theirs ";
    gCT = "git checkout --theirs (gCl)";

    # Fetch (f)
    gf = "git fetch";
    gfm = "git pull";
    gfc = "git clone";

    # Index (i)
    gia = "git add";
    giA = "git add --patch";
    giu = "git add --update";
    gid = "git diff --cached";
    gix = "git reset";

    # Log (l)
    gl = "git log --topo-order --oneline";
    glg = "git log --topo-order --graph --oneline";

    # Merge (m)
    gm = "git merge --no-ff --no-edit";

    # Push (p)
    gp = "git push";
    gpf = "git push --force-with-lease";

    # Rebase (r)
    gr = "git rebase"; # --ignore-date
    gri = "git rebase --interactive";
    grm = "git rebase (git main-branch)";
    grmi = "git rebase main --interactive";
    grc = "git rebase --continue";
    grs = "git rebase --skip";
    grx = "git rebase --abort";

    # Stash (s)
    gs = "git stash";
    gsx = "git stash drop";
    gsp = "git stash pop";
    gsl = "git stash list";
    gsd = "git stash show --patch --stat";
    gss = "git stash show --stat";

    # Working copy (w)
    gws = "git status --short";
    gwS = "git status";
    gwd = "git diff";
    gwD = "git diff --word-diff";
    gwx = "";
  };

  # git-get
  programs.git.extraConfig.gitget = {
    root = "~/src"; # vs default "repos"... should I just keep "src" for my own work?
    skip-host = true;
    scheme = "https";
  };
}
