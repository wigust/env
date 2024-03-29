{ rustPlatform
, lib
, fetchFromSourcehut
, pam
, scdoc
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "greetd";
  version = "0.7.0";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = pname;
    rev = version;
    sha256 = "b+S3fuJ8gjnSQzLHl3Bs9iO/Un2ynggAplz01GjJvFI=";
  };

  cargoSha256 = "w6d8rIc03Qa2/TpztpyVijjd3y0Vo38+JDhsOkSFG5E=";

  nativeBuildInputs = [
    scdoc
    installShellFiles
  ];

  buildInputs = [
    pam
  ];

  postInstall = ''
    for f in man/*; do
      scdoc < "$f" > "$(sed 's/-\([0-9]\)\.scd$/.\1/' <<< "$f")"
      rm -f "$f"
    done
    installManPage man/*
  '';

  meta = with lib; {
    description = "Minimal and flexible login manager daemon";
    longDescription = ''
      greetd is a minimal and flexible login manager daemon
      that makes no assumptions about what you want to launch.
      Comes with agreety, a simple, text-based greeter.
    '';
    homepage = "https://kl.wtf/projects/greetd/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}
