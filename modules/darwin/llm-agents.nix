{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages =
    let
      agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    in [
      # agents.omp
    ];

  nix.settings = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };
}
