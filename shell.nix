{ pkgs ? import <nixpkgs> {} }:
let
  #ocamlPackages = pkgs.ocaml-ng.ocamlPackages_latest;
  ocamlPackages = pkgs.ocamlPackages;
  ocamlPackages' = ocamlPackages.overrideScope' (final: prev: {
    ocaml-redis = final.callPackage ./nix/redis {};
    ocaml-redis-sync = final.callPackage ./nix/redis/sync.nix {};
    ocaml-redis-lwt = final.callPackage ./nix/redis/lwt.nix {};
  });
in
pkgs.mkShell {
  packages = with ocamlPackages'; [
    cohttp-lwt-unix
    yojson
    ocaml-redis-lwt
    calendar
    uri
    cmdliner

    pkgs.ocamlformat
    ocaml
    dune_3
    utop

    pkgs.opam
    pkgs.redis
    pkgs.ngrok
    pkgs.curl
  ];
}
