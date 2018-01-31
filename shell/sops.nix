# shell.nix
with import <nixpkgs> { };
mkShell {
  # imports all files ending in .asc/.gpg and sets $SOPS_PGP_FP.
  sopsPGPKeyDirs = [
    "./keys/hosts"
    "./keys/users"
  ];
  # Also single files can be imported.
  #sopsPGPKeys = [ 
  #  "./keys/users/mic92.asc"
  #  "./keys/hosts/server01.asc"
  #];
  nativeBuildInputs = [
    (pkgs.callPackage <sops-nix> { }).sops-pgp-hook
  ];
}
