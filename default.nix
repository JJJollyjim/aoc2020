with builtins;
with (import <nixpkgs> { });
let
  haskellCompiler = pkgs.haskellPackages.ghcWithPackages (p: [ p.split p.vector (p.callPackage ./lib_hs {}) ]);

  # Add days here
  paths = [
    ./day1
    ./day2
    ./day3
    ./day4
    ./day5
    ./day6
    ./day7
    ./day8
    ./day9
    ./day10
    ./day11
  ];
  days = listToAttrs (map
    (path: rec {
      name = baseNameOf path;
      value = rec {
        bin = runCommandLocal
          "aoc-${name}"
          { src = filterSource (p: type: (type == "regular") && (match "[^.].*\.hs" (baseNameOf p)) != null) path; }
          "${haskellCompiler}/bin/ghc $src/Main.hs -O -outputdir . -o $out";

        parts = {
          a = writeShellScript "aoc-${name}-a" "${bin} a";
          b = writeShellScript "aoc-${name}-b" "${bin} b";
        };

        input = filterSource (p: type: (type == "regular") && (baseNameOf p == "input")) path;

        tests = lib.filterAttrs (_: x: x != null) (mapAttrs
           (partName: partBin:
            if name == "day5" && partName == "b" then null else
            runCommandLocal
              "aoc-${name}-${partName}-test"
              {
                data = filterSource (p: type: (type == "regular") && (elem (baseNameOf p) [ "test" "testout.${partName}" ])) path;
              }
              "diff -w $data/testout.${partName} <(${partBin} < $data/test) && touch $out"
          )
          parts);

        answers = mapAttrs
          (partName: partBin:
            runCommandLocal
              "aoc-${name}-${partName}-answer"
              { inherit input; }
              "${partBin} < $input/input | tee $out"
          )
          parts;
      };
    })
    paths);
in
days // {
  compiler = haskellCompiler;

  benchmarker = writeShellScript "aoc-benchmarker" ''${pkgs.hyperfine}/bin/hyperfine ${lib.escapeShellArgs (concatMap (day: ["${day.bin} a < ${day.input}/input" "${day.bin} b < ${day.input}/input"]) (attrValues days))}'';

  allTests = concatMap (day: attrValues day.tests) (attrValues days);
  allAnswers = concatMap (day: attrValues day.answers) (attrValues days);
}
