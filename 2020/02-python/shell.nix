let
  pkgs = import ../nix/nixpkgs.nix {};
  pythonEnv = pkgs.python38.withPackages (ps: [
    ps.black
    ps.mypy
  ]);
in
pkgs.mkShell {
  name = "02-python";
  buildInputs = [
    pythonEnv
  ];
}
