{ stdenv, runCommand, fetchgit, linux-pam, xorg, path }:

stdenv.mkDerivation {
  name = "ly";
  version = "77f6958241646e3f315f27bc38212c3c4e1e7a8d";
  src =
    let
      # locally modify `nix-prefetch-git` to recursively use upstream’s .github as .gitmodules…
      fetchgitMod = args:
        (fetchgit args).overrideAttrs (oldAttrs: {
          fetcher = runCommand "nix-prefetch-git-mod" { } ''
            cp ${path}/pkgs/build-support/fetchgit/nix-prefetch-git $out
            sed '/^init_submodules\(\)/a [ -e .gitmodules ] || cp .github .gitmodules || true' -i $out
            chmod 755 $out
          '';
        });
    in
    fetchgitMod {
      url = "https://github.com/nullgemm/ly.git";
      rev = "77f6958241646e3f315f27bc38212c3c4e1e7a8d";
      sha256 = "05fqpinln1kbxb7cby1ska3nfw9xf60ig2h2nj0xv167fsrqlhly";
      fetchSubmodules = true;
      deepClone = true;
    };
  makeFlags = [ ];
  buildInputs = [ linux-pam xorg.libxcb xorg.xauth ];

  preConfigure = ''
    sed '/^FLAGS=/a FLAGS+= -Wno-error=unused-result' -i sub/termbox_next/makefile
  '';

  meta.platforms = stdenv.lib.platforms.linux;
}
