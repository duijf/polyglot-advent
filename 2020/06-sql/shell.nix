let
  pkgs = import ../nix/nixpkgs.nix {};
in
pkgs.mkShell {
  name = "06-sql";
  buildInputs = [
    pkgs.postgresql_12
  ];
}
