final: prev: {
  uplink = final.stdenv.mkDerivation rec {
    name = "uplink";
    version = "latest";

    nativeBuildInputs = with final; [ autoPatchelfHook ];

    src = final.fetchzip {
      url =
        "https://github.com/storj/storj/releases/${version}/download/uplink_linux_amd64.zip";
      sha256 = "sha256-67dkdAi7vECGpLE153/r+ojjUiI7UOldLQLLl36VVDM=";
    };

    installPhase = ''
      mkdir -p $out/bin
      chmod 755 uplink
      cp uplink $out/bin/
    '';
  };
  haskellPackages = prev.haskellPackages.extend (haskellFinal: haskellPrev: {
    hindent = haskellPrev.hindent.overrideAttrs (old: {
      src = final.fetchFromGitHub {
        owner = "mihaimaruseac";
        repo = "hindent";
        rev = "1917b7b9ac2cb3dcb152f4435de61d1858a4064b";
        sha256 = "sha256-oFzdyyaWHEIm/zzzdg8hJqk/xMCX4jEm2kVGLPmv9WY=";
        fetchSubmodules = true;
      };
      broken = false;
    });
  });
}
