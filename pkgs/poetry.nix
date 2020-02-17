{ lib, python35Packages, callPackage, ... }:

let
  ps = python35Packages;
  cleo6 = ps.cleo.overridePythonAttrs (oldAttrs: rec {
    version = "0.6.8";
    src = ps.fetchPypi {
      inherit (oldAttrs) pname;
      inherit version;
      sha256 = "06zp695hq835rkaq6irr1ds1dp2qfzyf32v60vxpd8rcnxv319l5";
    };
  });
  glob2 = callPackage ./glob2.nix { };

in ps.buildPythonPackage rec {
  pname = "poetry";
  version = "0.12.17";

  src = ps.fetchPypi {
    inherit pname version;
    sha256 = "0gxwcd65qjmzqzppf53x51sic1rbcd9py6cdzx3aprppipimslvf";
  };

  postPatch = ''
    substituteInPlace setup.py --replace \
      "requests-toolbelt>=0.8.0,<0.9.0" \
      "requests-toolbelt>=0.8.0,<0.10.0" \
      --replace 'pyrsistent>=0.14.2,<0.15.0' 'pyrsistent>=0.14.2,<0.16.0'
  '';

  format = "pyproject";

  propagatedBuildInputs = with ps; [
    cachy
    cleo6
    requests
    cachy
    requests-toolbelt
    jsonschema
    pyrsistent
    pyparsing
    cachecontrol
    lockfile
    pkginfo
    html5lib
    shellingham
    tomlkit
  ] ++ lib.optionals (ps.isPy27 || ps.isPy34) (with ps; [ typing pathlib2 glob2 ])
    ++ lib.optionals ps.isPy27 (with ps; [ virtualenv functools32 subprocess32 ]);

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions"
    "$out/bin/poetry" completions bash > "$out/share/bash-completion/completions/poetry"
    mkdir -p "$out/share/zsh/vendor-completions"
    "$out/bin/poetry" completions zsh > "$out/share/zsh/vendor-completions/_poetry"
    mkdir -p "$out/share/fish/vendor_completions.d"
    "$out/bin/poetry" completions fish > "$out/share/fish/vendor_completions.d/poetry.fish"
  '';

  # No tests in Pypi tarball
  doCheck = false;
  checkInputs = with ps; [ pytest ];
  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    homepage = https://github.com/sdispater/poetry;
    description = "Python dependency management and packaging made easy";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}