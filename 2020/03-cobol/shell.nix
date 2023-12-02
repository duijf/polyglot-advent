let
  pkgs = import ../nix/nixpkgs.nix {};
in
pkgs.mkShell {
  name = "03-cobol";
  buildInputs = [
    pkgs.gnu-cobol
  ];
}
