{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    steam
    steam.run

    # Eve related
    # eve-online
    # pyfa
  ];

  sound.enable = true;

  hardware = {
    opengl = rec {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        libva
        libGL_driver
        config.boot.kernelPackages.nvidia_x11.out
      ];
      extraPackages32 = with pkgs; [ libva libGL_driver ];
    };
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
  };

  # better for steam proton games
  systemd.extraConfig = "DefaultLimitNOFILE=1048576";

  # improve wine performance
  environment.sessionVariables = { WINEDEBUG = "-all"; };
}
