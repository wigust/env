self: super:
{
  summoner = self.stdenv.mkDerivation rec {
    name = "summoner-cli";
    version = "2.0.1.1";

    nativeBuildInputs = [
      self.autoPatchelfHook
    ];

    buildInputs = with self; [
      gmp
    ];

    src = self.fetchurl {
      url = "https://github.com/kowainik/summoner/releases/download/v${version}/summon-cli-linux";
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
      homepage = https://github.com/kowainik/summoner;
      description = "Summoner is a tool for scaffolding fully configured batteries-included production-level Haskell projects.";
      platforms = platforms.all;
      maintainers = with maintainers; [ bbuscarino ];
    };
  };
}
