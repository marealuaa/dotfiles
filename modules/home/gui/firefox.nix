{
  flake.modules.nixos.gui = { ... }: {

    programs.firefox = {
      enable = true;
      languagePacks = [ "en-GB" "it" ];

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never";
        DisplayMenuBar = "default-off";
        SearchBar = "unified";

        ExtensionSettings = {
          "*" = {
            installation_mode = "blocked";
          };

          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };

          "{7bb75c44-40b6-46a2-b239-fd29d198fcf5}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/kanagawa-dragon-nvim/latest.xpi";
            installation_mode = "force_installed";
          };

        };


        Preferences = {

          "network.trr.mode" = { Value = 3; Status = "locked"; };
          "network.trr.uri" = { Value = "https://mozilla.cloudflare-dns.com/dns-query"; Status = "locked"; };

          "fission.autostart" = { Value = true; Status = "locked"; };

          "network.dns.disablePrefetch" = { Value = true; Status = "locked"; };
          "network.prefetch-next" = { Value = false; Status = "locked"; };
          "network.http.sendRefererHeader" = { Value = 2; Status = "locked"; };
          "dom.security.https_only_mode" = { Value = true; Status = "locked"; };
          "gfx.webrender.all" = { Value = true; Status = "locked"; };
          "ui.systemUsesDarkTheme" = { Value = 1; Status = "locked"; };
          "browser.uidensity" = { Value = 1; Status = "locked"; };

          "browser.startup.homepage" = { Value = "about:blank"; Status = "locked"; };
          "browser.newtabpage.enabled" = { Value = false; Status = "locked"; };
          "browser.startup.page" = { Value = 0; Status = "locked"; };
        };
      };
    };
  };
}
