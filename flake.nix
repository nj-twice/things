{
  description = "things";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs: {

    packages = builtins.mapAttrs (
      system: pkgs:
      let
        my_drv = pkgs.stdenv.mkDerivation rec {
          name = "things";
          version = "0.1.0";
          src = inputs.self;

          interpreter = "${pkgs.fish}/bin/fish";

          shebang = "#!${interpreter}";
          newPathLine = "set -gx PATH $PATH ${pkgs.borgbackup}/bin";
          installPhase = ''
            ${interpreter} -l -N -P ${./nix/install.fish}  # The flags are needed to avoid fish returning an error
          '';
        };
      in
      {
        default = my_drv;
      }
    ) inputs.nixpkgs.legacyPackages;

    devShells = builtins.mapAttrs (system: pkgs: {
      default = pkgs.mkShell {
        inputsFrom = [
          inputs.self.packages.${system}.default
        ];
        # packages = with pkgs; [
        #   borgbackup
        # ];
      };
    }) inputs.nixpkgs.legacyPackages;

  };
}
