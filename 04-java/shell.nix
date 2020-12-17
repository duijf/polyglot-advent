let
  pkgs = import ../nix/nixpkgs.nix {};
in
pkgs.mkShell {
  name = "04-java";
  buildInputs = [
    pkgs.jdk14
  ];
}
