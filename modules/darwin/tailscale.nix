{ pkgs, ... }:
{
  services.tailscale.enable = true;

  system.activationScripts.tailscaleShieldsUp.text = ''
    if ${pkgs.tailscale}/bin/tailscale status >/dev/null 2>&1; then
      ${pkgs.tailscale}/bin/tailscale set --shields-up >/dev/null 2>&1 || true
    fi
  '';
}
