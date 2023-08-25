{ buildDunePackage, fetchFromGitHub, re, stdlib-shims, uuidm }:
buildDunePackage rec {
  pname = "redis";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "0xffea";
    repo = "ocaml-redis";
    rev = "v${version}";
    sha256 = "sha256-+q0fhWW/T/Q7Aof5cMDyVai/DyeMld/C9YEau6LN+J4=";
  };

  duneVersion = "3";

  propagatedBuildInputs = [ re stdlib-shims uuidm ];
}
