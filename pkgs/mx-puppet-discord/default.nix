# This file has been generated by node2nix 1.8.0. Do not edit!

{ stdenv, lib, pkgs, fetchFromGitHub, nodejs, nodePackages, pkg-config, cairo, pango, libpng, libjpeg, giflib, librsvg, makeWrapper, callPackage }:

let
  nodeEnv = import ./node-env.nix {
    inherit (pkgs) stdenv python2 utillinux runCommand writeTextFile;
    inherit nodejs;
    libtool = if pkgs.stdenv.isDarwin then pkgs.darwin.cctools else null;
  };
in

# { stdenv, pkgs, fetchFromGitHub, nodejs, nodePackages, pkg-config, cairo, pango, libpng, libjpeg, giflib, librsvg, makeWrapper, callPackage }:

let
  src = fetchFromGitHub {
    owner = "matrix-discord";
    repo = "mx-puppet-discord";
    rev = "a3b493da2fc4cdf2fe485b93eefc6ec514c12aac";
    sha256 = "sha256-uU8x+wLhfjbTwyDaTBdJQkcRj4d9LQcQvlmAB0oh82M=";
  };

  nodeComposition = callPackage ./node-packages.nix { inherit nodeEnv; };

  package = nodeComposition.shell.override {
    inherit src;

    buildInputs = [ cairo pango libpng libjpeg giflib librsvg ];
    nativeBuildInputs = [ nodePackages.node-pre-gyp nodePackages.node-gyp pkg-config ];
  };
in
stdenv.mkDerivation rec {
  pname = "mx-puppet-discord";
  version = "2020-11-14";
  inherit src;

  buildInputs = [ nodejs makeWrapper ];

  inherit (package) nodeDependencies;

  buildPhase = ''
    ln -s $nodeDependencies/lib/node_modules
    npm run-script build
    sed -i '1i #!${nodejs}/bin/node\n' build/index.js
  '';

  installPhase = ''
    cp -r . $out
    mkdir -p $out/bin
    chmod a+x $out/build/index.js
    makeWrapper $out/build/index.js $out/bin/${pname}
  '';

  meta = with lib; {
    platforms = platforms.linux;
  };
}
