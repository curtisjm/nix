{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        openvpn
        nmap
        netcat
        tcpdump
        inetutils
        samba
        burpsuite
    ];
}
