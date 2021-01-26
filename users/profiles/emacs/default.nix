{ pkgs, config, lib, ... }:
{
  home.file = { };

  services.emacs = {
    enable = true;
    client.enable = true;
  };

  programs.emacs = {
    enable = true;
    package =
      (pkgs.emacsWithPackagesFromUsePackage {
        config = ./.emacs.d/init.org;

        package = pkgs.emacsGcc;
        alwaysEnsure = true;
        alwaysTangle = true;
        extraEmacsPackages = epkgs: [
          (epkgs.melpaBuild {
            pname = "ligature";
            ename = "ligature";
            version = "1";
            recipe = builtins.toFile "recipe" ''
              (ligature :fetcher github
              :repo "mickeynp/ligature.el")
            '';
            src = pkgs.fetchFromGitHub {
              owner = "mickeynp";
              repo = "ligature.el";
              rev = "c830b9d74dcf4ff08e6f19cc631d924ce47e2600";
              hash = "sha256-cFaXfL7qy1ocjTsQdWxciojTKNTjc6jVUkdvIN2AiKg=";
            };
          })

          epkgs.cl-lib
        ];
      });
  };

  home.packages = with pkgs;
    [
      ripgrep
      fd

      pandoc

      xclip
      samba

      ispell
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))

      sqlite
    ];
}
