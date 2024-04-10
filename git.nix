{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    userName = lib.mkDefault "Claire Gaestel";
    userEmail = lib.mkDefault "213631+nyobe@users.noreply.github.com";
    ignores = [
      ".DS_Store"
    ];
  };

  # vs home.shellAliases?
  programs.fish.shellAbbrs = {
    # based on https://github.com/sorin-ionescu/prezto/blob/master/modules/git/alias.zsh
    g = "git";

    # Branch (b)
    gb = "git branch";
    gba = "git checkout -b";
    gbl = "git branch --verbose";
    gbx = "git branch --delete";
    gbX = "git branch --delete --force";
    gbm = "git branch --move";
    gbM = "git reset --keep";
    gbc = "git branch -v | grep gone #??";

    # Commit (c)
    gc = "git commit --verbose";
    gcf = "git commit --amend --reuse-message HEAD";
    gcF = "git commit --amend HEAD";
    gco = "git checkout";
    gcom = "git checkout main";
    gcp = "git cherry-pick --ff";
    gcx = "git revert";
    gcX = "git reset --hard HEAD^";
    gcs = "git show";
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
    gm = "git merge --no-ff";

    # Push (p)
    gp = "git push";
    gpf = "git push --force-with-lease";

    # Rebase (r)
    gr = "git rebase";
    gri = "git rebase --interactive";
    grm = "git rebase main";
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

    # Working copy (w)
    gws = "git status --short";
    gwS = "git status";
    gwd = "git diff";
    gwD = "git diff --word-diff";
    gwx = "";
  };

  # git-get
  home.packages = [
    pkgs.git-get
  ];
  programs.git.extraConfig.gitget = {
    root = "~/src"; # vs default "repos"... should I just keep "src" for my own work?
    skip-host = true;
    scheme = "https";
  };
}
