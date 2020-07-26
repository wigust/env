self: super:

let master = ((import ../sources).master) { config.allowUnfree = true; };
in { steam = master.steam; }
