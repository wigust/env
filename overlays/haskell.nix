self: super:

let
  ormolu = import (super.fetchFromGitHub {
    owner = "tweag";
    repo = "ormolu";
    rev = "913a927f398a4bfa478922d851c080281e83bc8c";
    sha256 = "0az6svwj7brcq42y238wf4d43mw5v8ykcf3kh52d009azxf8xn6f";
  }) { pkgs = self; };
in {
  haskell = super.haskell // {
    packages = super.haskell.packages // {
      "${ormolu.ormoluCompiler}" =
        super.haskell.packages.${ormolu.ormoluCompiler}.override {
          overrides = ormolu.ormoluOverlay;
        };
    };
  };
  summoner = self.stdenv.mkDerivation rec {
    name = "summoner-cli";
    version = "2.0.1.1";

    nativeBuildInputs = [ self.autoPatchelfHook ];

    buildInputs = with self; [ gmp ];

    src = self.fetchurl {
      url =
        "https://github.com/kowainik/summoner/releases/download/v${version}/summon-cli-linux";
      sha256 = "05y1q386fvfaxccgykz8fh2dl0bxjbigkshmz5akqkc3zjml3lkg";
    };

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      install -m755 -D ${src} $out/bin/summon
    '';

    meta = with self.stdenv.lib; {
      homepage = "https://github.com/kowainik/summoner";
      description =
        "Summoner is a tool for scaffolding fully configured batteries-included production-level Haskell projects.";
      platforms = platforms.all;
      # maintainers = with maintainers; [ bbuscarino ];
    };
  };
  haskell-language-server = (import (super.fetchFromGitHub {
    owner = "bbuscarino";
    repo = "hls-nix";
    rev = "50f22524ae9583ebf0d17c23b2f686ecc76a74d8";
    sha256 = "1y2ryy5mggggdlqmk4jkwgy8yjkfcvbag1dwpqnv8a28bs3md716";
    fetchSubmodules = false;
  }) {
    version = "8.8.3";
    tag = "0.2.2";
  }).exes.haskell-language-server;
}
