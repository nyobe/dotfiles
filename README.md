# Bootstrap
1. Install nix: https://github.com/DeterminateSystems/nix-installer
1. Clone repo to ~/.config/home-manager. (This is the default location that home-manager looks)
1. Add a new host to flake.nix
1. Initially run the activation script manually: `nix run .#home-configs.<user@hostname>.activationPackage`
1. Afterwards `home-manager switch` can be used.

