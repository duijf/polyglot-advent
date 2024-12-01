{
  mkShell,
  pkgs,
}:
mkShell {
  name = "advent-shell";
  buildInputs = [
    pkgs.go
  ];
}
