{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      theme = import ./theme.nix;
    in
    {
      packages.x86_64-linux = {
        # Combine nixpkgs with the packages added here
        pkgs = pkgs // removeAttrs self.packages.x86_64-linux [ "profiles" "pkgs" ];

        profiles = import ./profile.nix {
          inherit (self.packages.x86_64-linux) pkgs;
        };

        alacritty = pkgs.callPackage ./pkgs/alacritty.nix { inherit theme; };
        cilium = pkgs.callPackage ./pkgs/cilium.nix { };
        foliate = pkgs.libsForQt5.callPackage ./pkgs/foliate.nix { };
        git = pkgs.callPackage ./pkgs/git.nix { };
        julia = pkgs.callPackage ./pkgs/julia { };
        lemonbar-xft = pkgs.callPackage ./pkgs/lemonbar-xft.nix { };
        mx-puppet-discord = pkgs.callPackage ./pkgs/mx-puppet-discord { };
        rofi = pkgs.callPackage ./pkgs/rofi.nix { inherit theme; };
        signal-desktop = pkgs.callPackage ./pkgs/signal-desktop.nix { inherit theme; };
        xsecurelock = pkgs.callPackage ./pkgs/xsecurelock.nix { };
      };
    };
}
