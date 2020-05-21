self: super: {
  font-awesome-pro = self.stdenv.mkDerivation {
    name = "FontAwesome-Pro";
    src = self.fetchgit {
      "url" = "ssh://git@github.com/FortAwesome/Font-Awesome-Pro.git";
      "rev" = "8c120e016aae8bd28315164bbd2e047273da408f";
      "sha256" = "1zh45pxdm4a6pkc6dmijmckg2j92bw8d8lvchlnwargc6lkf750p";
      "fetchSubmodules" = false;
    };
    installPhase = ''
      install -m444 -Dt $out/share/fonts/opentype {fonts,otfs}/*.otf
    '';
  };
}
