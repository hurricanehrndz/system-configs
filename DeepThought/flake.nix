{
  # Input config, or package repos
  inputs = {
    # Nixpkgs, NixOS's official repo
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";

    snapraid-runner-src = {
      url = "github:Chronial/snapraid-runner";
      flake = false;
    };
  };


  # Output config, or config for NixOS system
  outputs = { self, nixpkgs, ... }@inputs: {
    # Define a system called "DeepThought"
    nixosConfigurations."DeepThought" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = [
        (import "${nixpkgs}/nixos/modules/profiles/headless.nix")
        ./configuration.nix
      ];
    };
  };
}
