let
  pkgs = import ../nix/nixpkgs.nix {};
in
pkgs.mkShell {
  name = "07-c";
  buildInputs = [
    pkgs.gcc
  ];
}
