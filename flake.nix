{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/20.09;

  outputs = { self, nixpkgs }: 
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
      {
        defaultPackage = forAllSystems (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in

            pkgs.python3Packages.buildPythonPackage rec {
                pname = "babypandas";
                version = "0.4.0";
                name = "${pname}-${version}";
                src = pkgs.fetchFromGitHub {
                  owner = "eldridgejm";
                  repo = "babypandas";
                  rev = "a186aee54afb329cb4c5aa41d17e88986e9afa00";
                  sha256 = "sha256-rTmcciCd6Yxl+LYjxFXmu+Sk3TDhFZfcGPYjOCVvt8Y=";
                };
                nativeBuildInputs = with pkgs.python38Packages; [ pytest pytestrunner ];
                propagatedBuildInputs = with pkgs.python38Packages; [ pandas ];
                doCheck = false;
              }

        );
      };
}
