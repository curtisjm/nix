let
  dnsenum = import ./dnsenum.nix;
  claude-code = import ./claude-code.nix;
in
{
  inherit dnsenum claude-code;
  default = final: prev:
    (dnsenum final prev) // (claude-code final prev);
}
