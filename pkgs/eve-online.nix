{ steam
, stdenv
, makeDesktopItem
, fetchurl
, protobuf
, writeScriptBin
, autoPatchelfHook
, wayland
, xorg
, qt512
, libGL
, cups
, alsaLib
, gstreamer
, libxml2
, openssl_1_0_2
, gst_plugins_base
, bashInteractive
}:

with stdenv;
let
  steam-run = (steam.override { nativeOnly = true; }).run;
  script = writeScriptBin "eve-online" ''
    #!${stdenv.shell}
    ${steam.run}/bin/steam-run @out@/launcher/evelauncher
  '';
in
mkDerivation rec {
  name = "eve-online";
  version = "1747682";

  src = fetchurl {
    url = "https://binaries.eveonline.com/evelauncher-${version}.tar.gz";
    sha256 = "1jhbd9n87rrz0ssgrqw962kr45cjc567c7s6jr4bfzrdjfwz9k4q";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ steam.run autoPatchelfHook bashInteractive ];

  buildInputs = [
    alsaLib
    cups
    gst_plugins_base
    gstreamer
    libGL
    libxml2
    openssl_1_0_2
    protobuf
    qt512.qtgamepad
    qt512.qtmultimedia
    qt512.qtwayland
    qt512.qtwebview
    wayland
    xorg.libX11
    xorg.libXcomposite
  ];

  installPhase = ''
    mkdir -p $out/launcher
    mkdir -p $out/bin
    cp -r . $out/launcher/
    cp -r ${
      makeDesktopItem {
        name = "com.ccp.eve-online";
        exec = "${steam.run}/bin/steam-run @out@/launcher/evelauncher";
        terminal = "false";
        desktopName = "Eve Online";
        genericName = "Internet Spaceships";
        comment = meta.description;

      }
    }/* $out/

    cp ${script}/bin/eve-online $out/bin/eve-online
    substituteAllInPlace $out/share/applications/*
    substituteAllInPlace $out/bin/eve-online
  '';

  meta = with stdenv.lib; {
    license = licenses.unfree;
    description =
      "Eve Online is a space-based, persistent world massively multiplayer online role-playing game developed and published by CCP Games.";
  };
}
