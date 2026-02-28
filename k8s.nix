{pkgs, ...}: {
  home.packages = [
    pkgs.kubectl
    pkgs.kind
    pkgs.kubectx
  ];

  programs.fish.shellAbbrs = {
    k = "kubectl";
    kc = "kubectx";
    kns = "kubens";
    kpl = "kubectl get pods";
  };
}
