{ buildDunePackage, ocaml-redis, lwt }:
buildDunePackage {
  pname = "redis-lwt";
  inherit (ocaml-redis) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ ocaml-redis lwt ];
}
