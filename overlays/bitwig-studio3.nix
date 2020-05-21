self: super: {
  bitwig-studio3 = super.bitwig-studio1.overrideAttrs (oldAttrs: rec {
    name = "bitwig-studio-${version}";
    version = "3.0.3";

    src = builtins.fetchurl {
      url =
        "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
      sha256 = "162l95imq2fb4blfkianlkymm690by9ri73xf9zigknqf0gacgsa";
    };

    runtimeDependencies = [ super.pulseaudio ];
  });
}
