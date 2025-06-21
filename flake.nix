{
  description = "Odin development using unstable packages";

  inputs.self.submodules = true;

  inputs = {
    #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    odin-flake.url = "path:odin-flake";
    #odin-flake.url = "github:freli/odin-flake?rev=c5f605c689f2eecb32074b107252c5d0c8131da8";

    # Old style
    #odin-syslib-flake.url = "path:odin-flake";
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      odin-flake = inputs.odin-flake.packages.x86_64-linux;
      pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };

      #####################################
      # Pinned versions
      #####################################

      pinned_raylib_pkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/e73c3bf29132da092f9c819b97b6e214367eb71f.tar.gz";
        sha256 = "0vlbgwl47vfx0a7irmkykaymd562zfdphfpxzh3kmbjgpnca1d1c";
      }) { system = "x86_64-linux";};

      pinned_SDL2_pkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/c2c0373ae7abf25b7d69b2df05d3ef8014459ea3.tar.gz";
        sha256 = "19a98q762lx48gxqgp54f5chcbq4cpbq85lcinpd0gh944qindmm";
      }) { system = "x86_64-linux";};

      pinned_SDL3_pkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/e73c3bf29132da092f9c819b97b6e214367eb71f.tar.gz";
        sha256 = "0vlbgwl47vfx0a7irmkykaymd562zfdphfpxzh3kmbjgpnca1d1c";
      }) { system = "x86_64-linux";};

    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {

        packages = with pkgs; [

          # Odin specific
          # Odin flake patched to use system libraries
          odin-flake.odin # Fast, concise, readable, pragmatic and open sourced programming language
          odin-flake.ols # Language server for the Odin programming language

          # Old style:
          #inputs.odin-syslib-flake.packages."${system}".odin-syslib
          #ols # Language server for the Odin programming language

          # General development tools
          go-task # Task runner / simpler Make alternative written in Go

          #####################################
          # Project specific libraries
          #####################################

          ###################
          # raylib
          ###################

          # System default
          #raylib # Simple and easy-to-use library to enjoy videogames programming

          # Pinned (5.5)
          pinned_raylib_pkgs.raylib

          ###################
          # SDL2
          ###################

          # System default
          # ( uses sdl2-compat: SDL2 compatibility layer that uses SDL3 behind the scenes)
          #SDL2
          #SDL2_ttf

          # Pinned (2.0.22)
          pinned_SDL2_pkgs.SDL2
          pinned_SDL2_pkgs.SDL2_ttf

          ###################
          # SDL3
          ###################

          # System default
          #sdl3
          #sdl3-ttf

          # Pinned (3.2.10)
          pinned_SDL3_pkgs.sdl3
          pinned_SDL3_pkgs.sdl3-ttf

        ];
      };
    };
}

