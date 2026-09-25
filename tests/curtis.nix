# Run from the repo: nix eval --impure --no-write-lock-file --json \
#   .#nixosConfigurations.curtis.config --apply 'c: import ./tests/curtis.nix c'
c:
let
  home = c.home-manager.users.curtis;
  packages = map (p: p.pname or p.name) c.environment.systemPackages;
in
assert c.networking.hostName == "curtis";
assert c.system.build.toplevel.system == "x86_64-linux";
assert c.boot.loader.systemd-boot.enable;
assert c.services.qemuGuest.enable;
assert c.fileSystems."/".device == "/dev/disk/by-label/curtis-root";
assert c.fileSystems."/boot".device == "/dev/disk/by-label/CURTIS_EFI";
assert !c.services.xserver.enable;
assert !c.programs.firefox.enable;
assert !c.services.pipewire.enable;
assert !c.networking.networkmanager.enable;
assert c.services.openssh.enable;
assert !c.services.openssh.openFirewall;
assert !c.services.openssh.settings.PasswordAuthentication;
assert !c.services.openssh.settings.KbdInteractiveAuthentication;
assert c.services.openssh.settings.PermitRootLogin == "no";
assert c.networking.firewall.enable;
assert !(builtins.elem 22 c.networking.firewall.allowedTCPPorts);
assert c.networking.firewall.interfaces.tailscale0.allowedTCPPorts == [ 22 ];
assert c.services.tailscale.enable;
assert c.services.tailscale.extraSetFlags == [ "--shields-up=false" ];
assert builtins.length c.users.users.curtis.openssh.authorizedKeys.keys == 1;
assert c.security.sudo.wheelNeedsPassword;
assert !c.virtualisation.docker.enable;
assert home.programs.tmux.enable && home.programs.git.enable;
assert home.programs.direnv.enable && home.programs.direnv.nix-direnv.enable;
assert home.programs.neovim.enable;
assert builtins.all (name: builtins.elem name packages) [ "codex" "claude-code" "opencode" ];
{
  passed = true;
  # Force full system evaluation, including NixOS/Home Manager assertions.
  system = c.system.build.toplevel.drvPath;
}
