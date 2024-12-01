{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    getPkgs = system:
      import nixpkgs {
        inherit system;
      };
  in {
    devShells = nixpkgs.lib.genAttrs ["aarch64-darwin" "x86_64-linux"] (
      system: let
        pkgs = getPkgs system;
      in {
        default = pkgs.callPackage ./shell.nix {};
      }
    );
  };
}
