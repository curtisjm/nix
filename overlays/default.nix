let
  dnsenum = import ./dnsenum.nix;
in
{
  inherit dnsenum;
  default = dnsenum;
}
