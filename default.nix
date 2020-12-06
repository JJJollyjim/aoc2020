with builtins;
with (import <nixpkgs> {});

let haskellLibDir = ./lib_hs;
    haskellCompiler = pkgs.haskellPackages.ghcWithPackages (p: [p.split]);

    # Add days here
    paths = [
      ./day1
      ./day2
      ./day3
      ./day4
      ./day5
      ./day6
    ];
in

listToAttrs (map (path: rec {
    name = baseNameOf path;
    value = rec {
      bin = runCommand
        "aoc-${name}"
        { src = filterSource (p: type: (type == "regular") && (match "[^.].*\.hs" (baseNameOf p)) != null) path; }
        "${haskellCompiler}/bin/ghc $src/Main.hs -O -i${haskellLibDir} -outputdir . -o $out";

      parts = {
        a = writeScript "aoc-${name}-a" "${bin} a";
        b = writeScript "aoc-${name}-b" "${bin} b";
      };

      input = filterSource (p: type: (type == "regular") && (baseNameOf p == "input")) path;

      tests = mapAttrs (partName: partBin:
        runCommand
          "aoc-${name}-${partName}-test"
          {
            data = filterSource (p: type: (type == "regular") && (elem (baseNameOf p) ["test" "testout.${partName}"])) path;
          }
          "diff -w $data/testout.${partName} <(${partBin} < $data/test) && touch $out"
      ) parts;

      answers = mapAttrs (partName: partBin:
        runCommand
          "aoc-${name}-${partName}-answer"
          { inherit input; }
          "${partBin} < $input/input | tee $out"
        ) parts;
    };
  }) paths) // {
    shell = mkShell {
      buildInputs = [ haskellCompiler ];
    };
  }
