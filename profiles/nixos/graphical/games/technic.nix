{ stdenv
, fetchurl
, makeWrapper
, jre
}:

# I'll use the default builder, because I don't need any particular
# features.
stdenv.mkDerivation rec {
  name = "technic-launcher";
  version = "608";

  # Simply fetch the JAR file of GINsim.
  src = fetchurl {
    url = "https://launcher.technicpack.net/launcher4/${version}/TechnicLauncher.jar";
    sha256 = "01bv4x8lnvs0jjhwz0ygh89qdzhhiz72zjl4df613nvaj0b2fs5j";
  };

  icon = fetchurl {
    url = "https://launcher.mojang.com/download/minecraft-launcher.svg";
    sha256 = "0w8z21ml79kblv20wh5lz037g130pxkgs8ll9s3bi94zn2pbrhim";
  };
  # I fetch the JAR file directly, so no archives to unpack.
  dontUnpack = true;

  # I need makeWrapper in my build environment to generate the wrapper
  # shell script.  This shell script will call the Java executable on
  # the JAR file of GINsim and will set the appropriate environment
  # variables.
  nativeBuildInputs = [ makeWrapper ];

  # The only meaningful phase of this build.  I create the
  # subdirectory share/java/ in the output directory, because this is
  # where JAR files are typically stored.  I also create the
  # subdirectory bin/ to store the executable shell script.  I then
  # copy the downloaded JAR file to $out/share/java/.  Once this is
  # done, I create the wrapper shell script using makeWrapper.  This
  # script wraps the Java executable (${jre}/bin/java) in the output
  # shell script file $out/bin/GINsim.  The script adds the argument
  # -jar … to the Java executable, thus pointing it to the actual
  # GINsim JAR file.  On my system (NixOS + XMonad), I need to set
  # some additional environment variables to get Java windows to
  # render properly.
  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp ${src} $out/share/java/${name}-${version}.jar

    makeWrapper ${jre}/bin/java $out/bin/${name} \
      --add-flags "-jar $out/share/java/${name}-${version}.jar" \
      --set _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=on' \
      --set _JAVA_AWT_WM_NONREPARENTING 1
  '';



  # Some easy metadata, in case I forget.
  meta = {
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.unix;
  };
}
