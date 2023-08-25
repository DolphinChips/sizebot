{ stdenv, lib, fetchFromGitHub
, ocaml, findlib, topkg, ocamlbuild
, cmdliner }:
stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-b0";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "b0-system";
    repo = "b0";
    rev = "v${version}";
    sha256 = "sha256-h0I7KeEembU9M29k8AmZdiQVkENmF/M14sp9uCkQQdg=";
  };

  buildInputs = [ cmdliner ];
  nativeBuildInputs = [ ocaml findlib topkg ocamlbuild ];

  inherit (topkg) buildPhase installPhase;
}
