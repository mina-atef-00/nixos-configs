# User configuration module
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  # Import only essential modules (temporarily removing mangowc due to build issues)
  imports = [
    # inputs.mangowc.hmModules.mango  # Commented out due to build issues
  ];

 # Home Manager configuration
  home = {
    username = "mina";
    homeDirectory = "/home/mina";
    stateVersion = "25.05"; # Match the system version

    # Disable the version check to suppress the warning
    enableNixpkgsReleaseCheck = false;

    # No package management here - all packages are system-wide
    packages = with pkgs; [
      # Only keep packages that are specifically needed in user profile
      # Most packages are now available system-wide
    ];

    # File management
    file = {
      ".config/nvim".source = ../../config/nvim;
      ".config/mpv".source = ../../config/mpv;
      ".config/kitty".source = ../../config/kitty;
    };
  };


  # Programs configuration
  programs = {
    home-manager.enable = true;

    # Fish shell configuration
    fish = {
      enable = true;
      shellAbbrs = {
        ll = "ls -la";
        ".." = "cd ..";
        "..." = "cd ../..";
        nrs = "sudo nixos-rebuild switch --flake .#nixos";
        hms = "home-manager switch --flake .#nixos";
      };
    };
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[→](bold green)";
          error_symbol = "[→](bold red)";
        };
        directory = {
          truncation_length = 3;
          truncation_symbol = "…/";
        };
      };
    };

    # Direnv integration
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };

    # Neovim configuration - using system-installed custom neovim with local config
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  # Services configuration
  services = {
    # Network tray
    network-manager-applet.enable = true;

    # GPG agent
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };

  # XDG configuration
 xdg = {
    enable = true;

    # Mime types
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "zen-browser.desktop";
        "x-scheme-handler/http" = "zen-browser.desktop";
        "x-scheme-handler/https" = "zen-browser.desktop";
        "x-scheme-handler/about" = "zen-browser.desktop";
        "x-scheme-handler/ftp" = "zen-browser.desktop";
        "x-scheme-handler/chrome" = "zen-browser.desktop";
        "application/x-extension-htm" = "zen-browser.desktop";
        "application/x-extension-html" = "zen-browser.desktop";
        "application/x-extension-shtml" = "zen-browser.desktop";
        "application/xhtml+xml" = "zen-browser.desktop";
        "application/x-extension-xhtml" = "zen-browser.desktop";
        "application/x-extension-xht" = "zen-browser.desktop";
        "audio/*" = "mpv.desktop";
        "video/*" = "mpv.desktop";
      };
    };

    # Desktop portal for Wayland
    desktopEntries = {
      zen-browser = {
        name = "Zen Browser";
        exec = "zen %U";
        type = "Application";
        mimeType = [
          "text/html"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ];
        categories = [
          "Network"
          "WebBrowser"
        ];
      };
    };
  };

  # Environment variables
 home.sessionVariables = {
    EDITOR = "nvim"; # System-installed
    BROWSER = "zen-browser"; # System-installed
    TERMINAL = "kitty"; # System-installed
    READER = "zathura"; # System-installed
    XDG_CURRENT_DESKTOP = "mangowc"; # Keep this for compatibility when mangowc is re-enabled
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    NIXOS_OZONE_WL = "1";
  };

}
