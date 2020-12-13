with (import <nixpkgs> { });
mkShell {
  buildInputs = [ (import ./default.nix).compiler stylish-haskell hlint haskellPackages.apply-refact ];
}
