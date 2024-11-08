{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    ,
    }:
    let
      overlay =
        final: prev: {
          picom = prev.picom.overrideAttrs (oldAttrs: rec {
            version = "master";
            src = ./.;

            buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ 
              prev.pcre
            ];
            nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ 
              prev.asciidoc
            ];
          });
        };
    in
    flake-utils.lib.eachDefaultSystem
      (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlays.default
              # overlay
            ];
          };
        in
        rec {
          packages.picom = pkgs.picom;
          packages.default = pkgs.picom;
        }
      )
     //{ overlays.default = overlay; };
}
