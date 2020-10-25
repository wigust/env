self: super: {
  # Adapted from https://github.com/NixOS/nixpkgs/pull/84408
  ly = super.ly.overrideAttrs (old: rec {
    version = "0.5.0";

    src = let
      # locally modify `nix-prefetch-git` to recursively use upstream’s .github as .gitmodules…
      fetchgitMod = args:
        (self.fetchgit args).overrideAttrs (oldAttrs: {
          fetcher = self.runCommand "nix-prefetch-git-mod" { } ''
            cp ${self.path}/pkgs/build-support/fetchgit/nix-prefetch-git $out
            sed '/^init_submodules\(\)/a [ -e .gitmodules ] || cat .github .gitea > .gitmodules || true' -i $out
            chmod 755 $out
          '';
        });
    in fetchgitMod {
      url = "https://github.com/cylgom/ly.git";
      rev = "v${version}";
      sha256 = "05fqpinln1kbxb7cby1ska3nfw9xf60ig2h2nj0xv167fsrqlhly";
    };
    makeFlags = [ ];
    buildInputs = with self; [ linux-pam xorg.libxcb ];

    preConfigure = ''
      sed '/^FLAGS=/a FLAGS+= -Wno-error=unused-result' -i sub/termbox_next/makefile
    '';

    meta.platforms = self.lib.platforms.linux;
  });
}
