{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      llvm
      clang
      cmake
      make
    ];
}
