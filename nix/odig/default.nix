{ stdenv, lib, fetchurl
, ocaml, findlib, topkg, ocamlbuild, b0
, cmdliner, odoc }:
stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-odig";
  version = "0.0.9";

  src = fetchurl {
    url = "https://erratique.ch/software/odig/releases/odig-${version}.tbz";
    sha256 = "sha256-sYKvGYkxeF5FmrNQdOyMAtlsJqhlmUESi9SkPn/cjM4=";
  };

  buildInputs = [ cmdliner odoc ];
  nativeBuildInputs = [ ocaml findlib topkg ocamlbuild b0 ];

  inherit (topkg) buildPhase installPhase;
}
