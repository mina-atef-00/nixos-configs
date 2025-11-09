# User configuration module
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  # Import modules including MangoWC
 imports = [
    # Add mango hm module
    inputs.mango.hmModules.mango
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
      # Nix-related fish shell aliases for efficient system administration
      shellAbbrs = {
        # Basic navigation
        ll = "ls -la";                    # List all files with details
        ".." = "cd ..";                   # Go up one directory
        "..." = "cd ../..";               # Go up two directories
        
        # NixOS rebuild commands
        nrc = "sudo nixos-rebuild check --flake .#nixos";        # Check configuration without applying
        nrs = "sudo nixos-rebuild switch --flake .#nixos";       # Apply configuration changes
        nrt = "sudo nixos-rebuild test --flake .#nixos";         # Test configuration without activation
        nrb = "sudo nixos-rebuild build --flake .#nixos";        # Build configuration without activation
        nro = "sudo nixos-rebuild switch --option accept-flake-config true --flake .#nixos"; # Rebuild with config acceptance
        
        # Home Manager commands
        hms = "home-manager switch --flake .#nixos";             # Apply home manager configuration
        hmb = "home-manager build --flake .#nixos";              # Build home manager configuration
        hmc = "home-manager check --flake .#nixos";              # Check home manager configuration
        
        # Nix garbage collection and storage management
        ngr = "sudo nix-collect-garbage";                        # Clean up unused store paths
        ngk = "sudo nix-collect-garbage -d";                     # Remove old generations and unused paths
        ngl = "nix store list-generations";                      # List system generations
        ngrm = "sudo nix-store --gc";                            # Run garbage collector
        ngrm1 = "sudo nix-store --delete-old";                   # Remove generations older than current
        ngrm0 = "sudo nix-store --delete-older-than 1d";         # Remove store paths older than 1 day
        nst = "nix-store --list-generations";                    # List nix store generations
        
        # Nix package management
        ns = "nix search";                                       # Search for packages
        ni = "nix-env -iA";                                      # Install package
        nr = "nix-env -e";                                       # Remove package
        nl = "nix-env -q";                                       # List installed packages
        nup = "nix-env -u";                                      # Upgrade packages
        nupall = "nix-env -u '*'";                               # Upgrade all packages
        
        # Nix flake commands
        nf = "nix flake";                                        # Flake operations
        nfu = "nix flake update";                                # Update flake lock file
        nfc = "nix flake check";                                 # Check flake outputs
        nfb = "nix build";                                       # Build flake outputs
        nfd = "nix develop";                                     # Enter development environment
        nsh = "nix shell";                                       # Enter nix shell environment
        nrm = "nix store delete";                                # Delete store paths
        
        # Nix channel management
        nc = "nix-channel";                                      # Channel operations
        ncu = "nix-channel --update";                            # Update channels
        ncl = "nix-channel --list";                              # List channels
        nca = "nix-channel --add";                               # Add channel
        ncr = "nix-channel --remove";                            # Remove channel
        
        # System and configuration management
        sysup = "sudo nixos-rebuild switch --upgrade --flake .#nixos"; # Upgrade system and apply config
        syschk = "nix flake check --all-systems --extra-experimental-features 'nix-command flakes'"; # Check flake validity
        sysgc = "sudo nix-collect-garbage && sudo nix-store --gc"; # Full system garbage collection
        sysdf = "nix store optimise";                            # Optimize nix store
        
        # Development shortcuts
        cdnix = "cd ~/nixos-configs";                            # Go to nixos configs directory
        vimnix = "nvim ~/nixos-configs";                         # Open nixos configs in vim
        gitnix = "cd ~/nixos-configs && git status";             # Check git status of configs
        gitnixup = "cd ~/nixos-configs && git pull origin main && nix flake check"; # Update and check configs
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

  # Window manager configuration
  wayland.windowManager.mango = {
    enable = true;
    settings = ''
      # MangoWC configuration will go here
      # See config.conf for details
    '';
    autostart_sh = ''
      # MangoWC autostart commands will go here
      # See autostart.sh for details
    '';
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
