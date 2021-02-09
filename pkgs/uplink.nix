{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  name = "uplink";
  version = "1.19.4";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    sha256 = "n+54Mpkjskab8tp4ib9WxyeC7ZdaLuu3Yj0gWD/M7ec=";
    fetchSubmodules = true;
  };

  vendorSha256 = "";

  meta = with lib; {
    description = "Simple command-line snippet manager, written in Go";
    homepage = "https://github.com/storj/storj";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
