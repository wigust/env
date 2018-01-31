{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  name = "storj";
  version = "1.24.4";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "899072b14794c94621da84bedc7f8e906ef488b4";
    sha256 = "1sHy4Azh8jxhifHCo4Wtgjq7MsD/Soj+Esc6ZCbMHxs=";
    fetchSubmodules = false;
  };

  vendorSha256 = "sha256-Qu+WjxgTpAjSy4ywbmqsGfnrpCr9z87KngMSYw99yRg=";

  meta = with lib; {
    description = "Simple command-line snippet manager, written in Go";
    homepage = "https://github.com/storj/storj";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
