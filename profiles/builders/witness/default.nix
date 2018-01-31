{ config, ... }: {
  nix.buildMachines = [{
    hostName = "witness-builder";
    systems = [ "x86_64-linux" ];
    maxJobs = 8;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  }];
  nix.distributedBuilds = true;
}
