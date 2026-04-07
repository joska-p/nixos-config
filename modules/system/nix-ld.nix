{ pkgs, ... }:
{
  # Enable nix-ld to run unpatched binaries (like Zed language servers)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];
}
