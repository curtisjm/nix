{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--shields-up" ];
    useRoutingFeatures = "client";
  };

  # Use systemd-resolved for split DNS so Tailscale's MagicDNS
  # only handles *.ts.net queries, not all DNS traffic
  services.resolved.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
}
