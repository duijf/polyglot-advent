let
  pkgs = import ../nix/nixpkgs.nix {};
in
pkgs.mkShell {
  name = "01-assembly";
  buildInputs = [
    pkgs.nasm
    pkgs.gdb
  ];
}
