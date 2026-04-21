let
  dnsenum = import ./dnsenum.nix;
in
{
  inherit dnsenum;
  default = final: prev: dnsenum final prev;
}
