{ pkgs ? import <nixpkgs> {} }:
let
  #ocamlPackages = pkgs.ocaml-ng.ocamlPackages_latest;
  ocamlPackages = pkgs.ocamlPackages;
  ocamlPackages' = ocamlPackages.overrideScope' (final: prev: {
    ocaml-redis = final.callPackage ./nix/redis {};
    ocaml-redis-lwt = final.callPackage ./nix/redis/lwt.nix {};
  });
in
ocamlPackages'.callPackage (
  { buildDunePackage, ocaml-redis-lwt, lwt, yojson, cohttp-lwt-unix, calendar, uri, cmdliner }:
  buildDunePackage {
    pname = "cocksizebot";
    version = "0.0.1";
    src = ./.;
    duneVersion = "3";
    buildInputs = [ ocaml-redis-lwt lwt yojson cohttp-lwt-unix calendar uri cmdliner ];
  }
) {}
