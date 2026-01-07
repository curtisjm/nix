{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        nmap
        netcat
        tcpdump
        inetutils
    ];
}
