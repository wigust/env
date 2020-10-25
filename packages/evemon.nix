{ stdenv, wine, python3Packages, fetchurl, makeDesktopItem, writeScriptBin }:
let wine64 = wine.override { wineBuild = "wine64"; };
in stdenv.mkDerivation rec {
  name = "evemon";
  version = "4.0.18";

  src = fetchurl {
    url =
      "https://github.com/peterhaneve/evemon/releases/download/${version}/EVEMon-binaries-${version}.zip";
    sha256 = "014hw82xa01k9jyd3ncgy4vsnr3ynspcj8idxpq3b4xn12bcpzgl";
  };

  buildPhase = ''
    ${env}/bin/python3 ./db_update.py
  '';

  installPhase = let
    script = writeScriptBin "pyfa" ''
      #!${stdenv.shell}
      ${env}/bin/python3 @out@/pyfa.py "$@"
    '';
  in ''
    runHook preInstall

    install -dm755 $out
    install -dm755 $out/usr/share/licenses/pyfa

    install -Dm644 ./config.py $out
    install -Dm644 ./db_update.py $out
    install -Dm644 ./eve.db $out
    install -Dm755 ./pyfa.py $out
    install -Dm644 ./README.md $out
    install -Dm644 ./version.yml $out

    cp -a ./eos $out
    cp -a ./graphs $out
    cp -a ./gui $out
    cp -a ./imgs $out
    cp -a ./service $out
    cp -a ./utils $out
    cp -r ${
      makeDesktopItem {
        inherit name;
        desktopName = name;
        comment = meta.description;
        exec = "@out@/bin/pyfa";
        terminal = "false";
        type = "Application";
        categories = "Application;Game";
      }
    }/* $out/

    install -Dm755 ${script}/bin/pyfa $out/bin/pyfa
    substituteAllInPlace $out/share/applications/*
    substituteAllInPlace $out/bin/pyfa

    runHook postInstall
  '';

  dontSetup = true;

  buildInputs = [ env ];

  meta = with stdenv.lib; {
    license = licenses.unfree;
    description = "Python Fitting Assistant";
  };
}
