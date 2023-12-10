{
  mkShell,
  pkgs,
}:
mkShell {
  name = "advent-shell";
  buildInputs = [
    pkgs.cargo
    pkgs.rustc
    pkgs.rust-analyzer
  ];
}