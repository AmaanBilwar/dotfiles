{ config, lib, pkgs, ... }:

# ponytail: no sops-nix — avoids building sops-install-secrets; bring back if you need templates/systemd
{
  home.activation.dearrowLicense = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export SOPS_AGE_KEY_FILE="${config.home.homeDirectory}/.config/sops/age/keys.txt"
    key=$(${pkgs.sops}/bin/sops -d --extract '["dearrow_license"]' ${../secrets/secrets.yaml})
    mkdir -p "${config.xdg.configHome}/chromium/policies/managed"
    ${pkgs.jq}/bin/jq -n --arg k "$key" \
      '{"3rdparty":{"extensions":{"enamippconapkdmgfgjchkhakpfinmaj":{"licenseKey":$k}}}}' \
      > "${config.xdg.configHome}/chromium/policies/managed/dearrow.json"
  '';
}
