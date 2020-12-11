# Pin the Nixpkgs repo at a specific commit for reproducibility.
let
  pkgsTarball = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/2cd2e7267e5b9a960c2997756cb30e86f0958a6b.tar.gz";
    sha256 = "sha256:0ir3rk776wldyjz6l6y5c5fs8lqk95gsik6w45wxgk6zdpsvhrn5";
  };
in
  import pkgsTarball