self: super:

let master = ((import ../sources).master) { config.allowUnfree = true; };
in { chromium = master.chromium; }
