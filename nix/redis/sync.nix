{ buildDunePackage, ocaml-redis, camlp-streams }:
buildDunePackage {
  pname = "redis-sync";
  inherit (ocaml-redis) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ ocaml-redis camlp-streams ];
}
