{
  # Input config, or package repos
  inputs = {
    # Nixpkgs, NixOS's official repo
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
  };

  # Output config, or config for NixOS system
  outputs = { self, nixpkgs, ... }@inputs: {
    # Define a system called "DeepThought"
    nixosConfigurations."DeepThought" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };
  };
}