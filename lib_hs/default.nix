with builtins;
{ mkDerivation, base, stdenv }:
mkDerivation {
  pname = "aoc";
  version = "0.1.0.0";
  src = filterSource (p: type: (type == "regular") && (elem (baseNameOf p) ["AOC.hs" "aoc.cabal"])) ./.;
  libraryHaskellDepends = [ base ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
