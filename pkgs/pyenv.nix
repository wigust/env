{ stdenv, fetchFromGitHub, bash, gcc9, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "pyenv";
  version = "1.2.20";

  src = fetchFromGitHub {
    owner = "pyenv";
    repo = "pyenv";
    rev = "4c302a022d653eb687c6b7b2d089d2a6cb55464a";
    sha256 = "m5osWP6ztcWf9guUqEIyHIxY5dMMxbaVEbNfWWLR4pg=";
    fetchSubmodules = true;
  };

  buildInputs = [ bash makeWrapper ];
  naviveBuildInputs = [ gcc9 ];

  buildPhase = "true";
  installPhase = ''
    mkdir $out
    ln -s ${src}/* $out
    rm $out/bin
    mkdir $out/bin
    makeWrapper ${src}/bin/pyenv $out/bin/pyenv \
      --set CC ${gcc9} \
      --set CPP ${gcc9}
  '';

  meta = with stdenv.lib; {
    description = "Simple Python version management";
    longDescription = ''
      pyenv lets you easily switch between multiple versions of Python.
    '';
    homepage = "https://github.com/pyenv/pyenv";
    changelog = "https://github.com/pyenv/pyenv/blob/master/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
