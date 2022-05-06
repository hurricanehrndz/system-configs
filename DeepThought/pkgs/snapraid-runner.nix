{ stdenv, lib, python310, snapraid-runner-src }:

stdenv.mkDerivation rec {
  pname = "snapraid-runner";

  version = snapraid-runner-src.shortRev;
  src = snapraid-runner-src;

  buildInputs = [
    python310
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${pname}.py $out/bin/${pname}
    chmod +x $out/bin/${pname}
  '';
}
