final: prev: {
  dnsenum = prev.dnsenum.overrideAttrs (old: {
    postFixup =
      let
        perlEnv = prev.perl.withPackages (
          ps: with ps; [
            RegexpIPv6
            NetIP
            NetDNS
            NetNetmask
            XMLWriter
            StringRandom
            NetWhoisIP
            WWWMechanize
          ]
        );
      in
      ''
        sed -i "1s|.*|#!${perlEnv}/bin/perl|" $out/bin/dnsenum
      '';
  });
}
