self: super:

let
  easyPS = import (super.fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";
    rev = "14e7d85431e9f9838d7107d18cb79c7fa534f54e";
    sha256 = "0lmkppidmhnayv0919990ifdd61f9d23dzjzr8amz7hjgc74yxs0";
  }) { pkgs = self; };
in { inherit (easyPS) spago purs pscid; }
