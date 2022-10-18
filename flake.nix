{
    description = "NixOS configuration";

    # All inputs for the system
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nur = {
            url = "github:nix-community/NUR";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    # All outputs for the system (configs)
    outputs = { home-manager, nixpkgs, nur, ... }@inputs: 
        let
            system = "x86_64-linux"; #current system
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            lib = nixpkgs.lib;
            user = "feng";

            # This lets us reuse the code to "create" a system
            # Credits go to sioodmy on this one!
            # https://github.com/sioodmy/dotfiles/blob/main/flake.nix
            mkSystem = pkgs: system: hostname: username:
                pkgs.lib.nixosSystem {
                    system = system;
                    modules = [
                        { networking.hostName = hostname; }
                        # General configuration (users, networking, sound, etc)
                        #./modules/system/configuration.nix
                        # Hardware config (bootloader, kernel modules, filesystems, etc)
                        # DO NOT USE MY HARDWARE CONFIG!! USE YOUR OWN!!
                        #(./. + "/hosts/${hostname}/hardware-configuration.nix")
                        ./hosts/${hostname}/hardware-configuration.nix
                        ./hosts/${hostname}/configuration.nix
                        home-manager.nixosModules.home-manager
                        {
                            home-manager = {
                                useUserPackages = true;
                                useGlobalPkgs = true;
                                extraSpecialArgs = { inherit inputs; };
                                # Home manager config (configures programs like firefox, zsh, eww, etc)
                                # users.${username} = (./. + "/hosts/${hostname}/home.nix");
                                users.${username} = {
                                  imports = 
                                    [
                                      ./modules/default.nix 
                                      ./hosts/${hostname}/home.nix
				    ];
                                };
                            };
                            # nixpkgs.overlays = [
                            #     # Add nur overlay for Firefox addons
                            #     nur.overlay
                            #     (import ./overlays)
                            # ];
                        }
                    ];
                    specialArgs = { inherit inputs username; };
                };

        in {
            nixosConfigurations = {
                # Now, defining a new system is can be done in one line
                #                                Architecture   Hostname Username
                laptop = mkSystem inputs.nixpkgs system "laptop" user;
                desktop = mkSystem inputs.nixpkgs system "desktop" user;
                vm = mkSystem inputs.nixpkgs system "vm" user;
                lxc = mkSystem inputs.nixpkgs system "lxc" user;
            };
    };
}
