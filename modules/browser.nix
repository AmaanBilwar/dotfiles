{
  self,
  inputs,
  lib,
  ...
}:
let
  inherit (lib.attrsets)
    attrNames
    concatMapAttrs
    filterAttrs
    getAttr
    hasAttr
    mapAttrs'
    mapAttrsToList
    nameValuePair
    optionalAttrs
    ;
  inherit (lib.lists)
    elemAt
    filter
    foldr
    head
    isList
    singleton
    ;
  inherit (lib.trivial)
    const
    importJSON
    warn
    flip
    ;
  inherit (lib.fixedPoints) fix;
  inherit (lib.strings)
    concatStrings
    concatStringsSep
    hasInfix
    isString
    match
    split
    splitString
    ;

  # UNSLOP
  extensions.consent-o-matic.id = "mdjildafknihdffpkfmmpnpoiajfjnjd";
  extensions.ublock-origin =
    let
      assets = importJSON "${inputs.ublock}/assets/assets.json";

      filterLists =
        (
          assets
          |> filterAttrs (_: spec: (spec.content or null) == "filters" && (spec.group or null) != "regions")
          |> flip removeAttrs [
            "ublock-experimental"
          ]
          |> attrNames
        )
        ++ [
          "TUR-0"
          "user-filters"

          "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/BrowseWebsitesWithoutLoggingIn.txt"
          "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/ClearURLs%20for%20uBo/clear_urls_uboified.txt"
          "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/LegitimateURLShortener.txt"
          "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/annoyance_list.txt"
          "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/click2load.txt"
          "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/privacy_essentials.txt"
        ];

      mkStylesheet =
        hostname: css:
        let
          normalize =
            string:
            split "[[:space:]]+" string |> filter (part: isString part && part != "") |> concatStringsSep " ";
        in
        split ''/\*([^*]|\*+[^*/])*\*+/'' css
        |> filter isString
        |> concatStrings
        |> split ''([^{}]+)\{([^{}]*)\}''
        |> filter isList
        |> map (
          rule:
          let
            selector = normalize (head rule);

            declarations =
              elemAt rule 1
              |> splitString ";"
              |> map normalize
              |> filter (declaration: declaration != "")
              |> map (
                declaration:
                if match ".*![[:space:]]*important" declaration == null then
                  "${declaration} !important"
                else
                  declaration
              );
          in
          if declarations == singleton "display: none !important" then
            "${hostname}##${selector}"
          else
            "${hostname}##${selector}:style(${concatStringsSep "; " declarations})"
        );
    in
    {
      id = "blockjmkbacgjkknlgpkjjiijinjdanf";
      preinstalled = true;

      settings.toolbar_pin = "force_pinned";

      policy.userSettings = [
        [
          "suspendUntilListsAreLoaded"
          "true"
        ]
        [
          "userFiltersTrusted"
          "true"
        ]
      ];

      policy.toOverwrite.filterLists =
        filter (name: !(hasInfix "://" name || name == "user-filters" || hasAttr name assets)) filterLists
        |> foldr (name: warn "helium: unknown ublock filter list: ${name}") filterLists;

      policy.toOverwrite.filters = [
        "dolap.com##.fancybox-wrap"
      ]
      # YOUTUBE
      ++ [
        # SHORTS -> WATCH
        ''||youtube.com/shorts/$document,uritransform=/^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([^\/?#]+)/https:\/\/www.youtube.com\/watch?v=\$1/''

        # TODO: Allow youtube embeds without click2load'ing, as they are broken: https://github.com/uBlockOrigin/uBlock-issues/issues/3868
        "@@||youtube.com/embed/$frame"
        "@@||youtube-nocookie.com/embed/$frame"
      ];
    };

  # YOUTUBE
  extensions.dearrow.id = "enamippconapkdmgfgjchkhakpfinmaj";
  extensions.sponsorblock.id = "mnjggcdmjocbbbhaepdhchncahnbgone";

  # VISUALS
  extensions.dark-reader.id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
  extensions.refined-github.id = "hlepfoohegkhhmjieoechaddaejaokhf";

  extensions.vimium-c.id = "hfjbmagddngcpeloejdejnfgbamkjaeg";

  extensions.bitwarden.id = "nngceckbapebfimnlniiiahkandclblb";
  extensions.seventv.id = "ammjkodgmmoknidbanneddgankgfejfh";
  extensions.go-full-page.id = "fdpohaocaechififmbbbbbknoalclacl";

  # SERVICES
  policy = {
    # EXTENSIONS
    ExtensionInstallBlocklist = singleton "*";

    ExtensionInstallAllowlist = policy.ExtensionInstallForcelist;
    ExtensionInstallForcelist =
      extensions
      |> filterAttrs (_: extension: !(extension.preinstalled or false))
      |> mapAttrsToList (const <| getAttr "id");

    ExtensionInstallSources = singleton "https://services.helium.imput.net/*";

    ExtensionSettings =
      extensions
      |> concatMapAttrs (
        _: extension: optionalAttrs (extension ? settings) { ${extension.id} = extension.settings; }
      );

    "3rdparty".extensions =
      extensions
      |> concatMapAttrs (
        _: extension: optionalAttrs (extension ? policy) { ${extension.id} = extension.policy; }
      );

    # MISC
    DefaultBrowserSettingEnabled = false;

    DeveloperToolsAvailability = 1;

    BatterySaverModeAvailability = 0;

    # "Continue where you left off" can't be set declaratively on a consumer machine:
    # - Preference `session.restore_on_startup` is HMAC-tracked, writing it externally trips Chromium's reset popup.
    # - Policy `RestoreOnStartup` is restricted by upstream Chromium to AD-joined / Cloud-Management-enrolled
    #   devices only (anti-hijack mitigation), so the managed plist value is loaded then ignored.
    #
    # TODO: Remove this comment when Helium on MacOS gets a toggle to disable these checks with an environment variable.
    RestoreOnStartup = 1;

    # SEARCH
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "DuckDuckGo";
    DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://ac.duckduckgo.com/ac/?q={searchTerms}";
    SearchSuggestEnabled = true;
  };

  preferences = {
    helium.completed_onboarding = true;
    helium.services.user_consented = true;

    helium.browser.layout = 1;
    helium.browser.rounded_frame = false;

    helium.browser.new_tab_next_to_active = true;

    bookmark_bar.show_on_all_tabs = false;
    bookmark_bar.show_tab_groups = false;

    download.prompt_for_download = false;

    # `extensions.settings` is HMAC-tracked. Writing it externally trips Chromium's reset popup warning.
    # Toggle it all manually in helium://extensions for now.
    # extensions.settings =
    #   extensions
    #   |> mapAttrs' (
    #     _: extension: nameValuePair extension.id ({ incognito = true; } // extension.preferences or { })
    #   );
  };
in
{
  flake.darwinModules.desktop = self.darwinModules.helium;
  flake.darwinModules.helium =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.attrsets) concatMapAttrs;
      inherit (lib.generators) toPlist;
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;
    in
    {
      system.defaults.CustomUserPreferences."net.imput.helium" = {
        SUEnableAutomaticChecks = false;
        SUAutomaticallyUpdate = false;
        SUSendProfileInfo = false;
      };

      system.services.helium-policy = {
        imports = singleton self.serviceModules.managed-files;

        managed-files = {
          inherit (pkgs) smfh nushell;

          files = {
            "/Library/Managed Preferences/net.imput.helium.plist".text = policy |> toPlist { escape = true; };
          }
          // (
            policy."3rdparty".extensions
            |> concatMapAttrs (
              id: extensionPolicy: {
                "/Library/Managed Preferences/net.imput.helium.extensions.${id}.plist".text =
                  extensionPolicy |> toPlist { escape = true; };
              }
            )
          );
        };
      };

      system.activationScripts.postActivation.text = "${pkgs.writers.writeNu "helium-default-browser.nu"
        /* nu */ ''
          (^/usr/bin/sudo
            --set-home
            --user (ls --long /dev/console | get 0.user)
            ${getExe pkgs.defaultbrowser} helium)
        ''
      }";
    };

  flake.nixosModules.desktop = self.nixosModules.helium;
  flake.nixosModules.helium =
    { lib, ... }:
    let
      inherit (lib.strings) toJSON;
    in
    {
      environment.etc."chromium/policies/managed/policies.json".text = toJSON policy;
    };

  flake.homeModules.desktop = self.homeModules.helium;
  flake.homeModules.helium =
    {
      lib,
      osConfig,
      ...
    }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.modules) mkIf;
      inherit (lib.trivial) const flip;
      inherit (lib.attrsets) genAttrs;
      inherit (lib.strings) toJSON;

      defaultPreferences.type = "copy";
      defaultPreferences.text = toJSON preferences;
    in
    {
      files."Library/Application Support/net.imput.helium/Default/Preferences" =
        mkIf osConfig.nixpkgs.hostPlatform.isDarwin defaultPreferences;
      xdg.config.files."helium/Default/Preferences" =
        mkIf osConfig.nixpkgs.hostPlatform.isLinux defaultPreferences;

      xdg.mime-apps.default-applications =
        mkIf osConfig.nixpkgs.hostPlatform.isLinux
        <| flip genAttrs (const "helium.desktop") [
          "application/pdf"
          "application/rdf+xml"
          "application/rss+xml"
          "application/xhtml+xml"
          "application/xhtml_xml"
          "application/xml"
          "image/gif"
          "image/jpeg"
          "image/png"
          "image/webp"
          "text/html"
          "text/xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ];

      packages = singleton inputs.helium.packages.${osConfig.nixpkgs.hostPlatform.system}.default;
    };
}

