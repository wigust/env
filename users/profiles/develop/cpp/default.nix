{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      llvm_11
      clang_11
      cmake
      cmake-format
      make
      gdb
      lldb_11
    ];
}
