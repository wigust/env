self: super:
let master = ((import ../sources).master) { };
in { nix-prefetch-github = master.nix-prefetch-github; }
