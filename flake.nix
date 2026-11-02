{
  description = "Typed zero-trust runtime for agentic workflows";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          jdk21
          sbt
          metals
        ];

        JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
      };
    };
}
