{
  description = "Private Home Manager configuration";

  inputs = {
    dotfiles.url = "github:nyobe/dotfiles";
  };

  outputs = inputs @ {dotfiles, ...}: {
    homeConfigurations."user@hostname" = dotfiles.lib.mkHome "x86_64-darwin" [
      {home.username = "user";}
    ];
  };
}
