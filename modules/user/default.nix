{ config, pkgs, lib, inputs, ... }:

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

  # Window manager configuration - this is where MangoWM should be configured in Home Manager
 wayland.windowManager.mango = {
    enable = true;
    settings = ''
                  # Window effect
                  blur=0
                  blur_layer=0
                  blur_optimized=1
                  blur_params_num_passes = 2
                  blur_params_radius = 5
                  blur_params_noise = 0.02
                  blur_params_brightness = 0.9
                  blur_params_contrast = 0.9
                  blur_params_saturation = 1.2

                  shadows = 0
                  layer_shadows = 0
                  shadow_only_floating = 1
                  shadows_size = 10
                  shadows_blur = 15
                  shadows_position_x = 0
                  shadows_position_y = 0
                  shadowscolor= 0x0000ff

                  border_radius=6
                  no_radius_when_single=0
                  focused_opacity=1.0
                  unfocused_opacity=1.0

                  # Animation Configuration(support type:zoom,slide)
                  # tag_animation_direction: 0-horizontal,1-vertical
                  animations=1
                  layer_animations=1
                  animation_type_open=slide
                  animation_type_close=slide
                  animation_fade_in=1
                  animation_fade_out=1
                  tag_animation_direction=1
                  zoom_initial_ratio=0.3
                  zoom_end_ratio=0.8
                  fadein_begin_opacity=0.5
                  fadeout_begin_opacity=0.8
                  animation_duration_move=500
                  animation_duration_open=400
                  animation_duration_tag=350
                  animation_duration_close=800
                  animation_duration_focus=0
                  animation_curve_open=0.46,1.0,0.29,1
                  animation_curve_move=0.46,1.0,0.29,1
                  animation_curve_tag=0.46,1.0,0.29,1
                  animation_curve_close=0.08,0.92,0,1
                  animation_curve_focus=0.46,1.0,0.29,1

                  # Scroller Layout Setting
                  scroller_structs=20
                  scroller_default_proportion=0.8
                  scroller_focus_center=0
                  scroller_prefer_center=0
                  edge_scroller_pointer_focus=1
                  scroller_default_proportion_single=1.0
                  scroller_proportion_preset=0.5,0.8,1.0

                  # Master-Stack Layout Setting
                  new_is_master=1
                  default_mfact=0.55
                  default_nmaster=1
                  smartgaps=0

                  # Overview Setting
                  hotarea_size=10
                  enable_hotarea=1
                  ov_tab_mode=0
                  overviewgappi=5
                  overviewgappo=30

                  # Misc
                  no_border_when_single=0
                  axis_bind_apply_timeout=100
                  focus_on_activate=1
                  inhibit_regardless_of_visibility=0
                  sloppyfocus=1
                  warpcursor=1
                  focus_cross_monitor=0
                  focus_cross_tag=0
                  enable_floating_snap=0
                  snap_distance=30
                  cursor_size=24
                  drag_tile_to_tile=1

                  # keyboard
                  repeat_rate=25
                  repeat_delay=600
                  numlockon=0
                  xkb_rules_layout=us,ara
                  xkb_rules_options=grp:win_space_toggle

                  # Trackpad
                  # need relogin to make it apply
                  disable_trackpad=0
                  tap_to_click=1
                  tap_and_drag=1
                  drag_lock=1
                  trackpad_natural_scrolling=0
                  disable_while_typing=1
                  left_handed=0
                  middle_button_emulation=0
                  swipe_min_threshold=1

                  # mouse
                  # need relogin to make it apply
                  mouse_natural_scrolling=0

                  # Appearance - Catppuccin inspired colors
                  gappih=5
                  gappiv=5
                  gappoh=10
                  gappov=10
                  scratchpad_width_ratio=0.8
                  scratchpad_height_ratio=0.9
                  borderpx=4
                  rootcolor=0x1e1e2eff
                  bordercolor=0x313244ff
                  focuscolor=0x89b4faff
                  maximizescreencolor=0x45475aff
                  urgentcolor=0xf38ba8ff
                  scratchpadcolor=0x585b70ff
                  globalcolor=0xb4befe
                  overlaycolor=0xa6adc8ff

                  # layout support:
                  # tile,scroller,grid,deck,monocle,center_tile,vertical_tile,vertical_scroller
                  tagrule=id:1,layout_name:scroller
                  tagrule=id:2,layout_name:scroller
                  tagrule=id:3,layout_name:scroller
                  tagrule=id:4,layout_name:scroller
                  tagrule=id:5,layout_name:scroller
                  tagrule=id:6,layout_name:scroller
                  tagrule=id:7,layout_name:scroller
                  tagrule=id:8,layout_name:scroller
                  tagrule=id:9,layout_name:scroller

                  # Key Bindings
                  # key name refer to `xev` or `wev` command output,
                  # mod keys name: super,ctrl,alt,shift,none

                  # reload config
                  bind=SUPER,r,reload_config

                  # menu and terminal
                  bind=SUPER,Return,spawn,kitty
                  bind=SUPER+SHIFT,f,spawn,firefox

                  # exit
                  bind=SUPER+SHIFT,e,quit
                  bind=SUPER,q,killclient

                  # switch window focus
                  bind=SUPER,Tab,focusstack,next
                  bind=SUPER,j,focusdir,left
                  bind=SUPER,l,focusdir,right
                  bind=SUPER,i,focusdir,up
                  bind=SUPER,k,focusdir,down

                  # swap window
                  bind=SUPER+SHIFT,j,exchange_client,left
                  bind=SUPER+SHIFT,l,exchange_client,right
                  bind=SUPER+SHIFT,i,exchange_client,up
                  bind=SUPER+SHIFT,k,exchange_client,down

                  # switch window status
                  bind=SUPER,g,toggleglobal
                  bind=SUPER,o,toggleoverview
                  bind=SUPER,m,togglefloating
                  bind=SUPER+SHIFT,m,togglemaximizescreen
                  bind=SUPER,f,togglefullscreen
                  bind=SUPER,u,toggle_scratchpad
                  bind=SUPER,i,minimized
                  bind=SUPER+SHIFT,I,restore_minimized

                  # scroller layout
                  bind=SUPER,minus,set_proportion,0.5
                  bind=SUPER,plus,set_proportion,0.8
                  bind=SUPER,equal,switch_proportion_preset

                  # switch layout
                  bind=SUPER,g,switch_layout

                  # tag switch
                  bind=SUPER,Left,viewtoleft,0
                  bind=SUPER,Right,viewtoright,0
                  bind=SUPER+CTRL,Left,tagtoleft,0
                  bind=SUPER+CTRL,Right,tagtoright,0

                  bind=SUPER,1,view,1,0
                  bind=SUPER,2,view,2,0
                  bind=SUPER,3,view,3,0
                  bind=SUPER,4,view,4,0
                  bind=SUPER,5,view,5,0
                  bind=SUPER,6,view,6,0
                  bind=SUPER,7,view,7,0
                  bind=SUPER,8,view,8,0
                  bind=SUPER,9,view,9,0

                  # tag: move client to the tag and focus it
                  bind=SUPER+SHIFT,1,tag,1,0
                  bind=SUPER+SHIFT,2,tag,2,0
                  bind=SUPER+SHIFT,3,tag,3,0
                  bind=SUPER+SHIFT,4,tag,4,0
                  bind=SUPER+SHIFT,5,tag,5,0
                  bind=SUPER+SHIFT,6,tag,6,0
                  bind=SUPER+SHIFT,7,tag,7,0
                  bind=SUPER+SHIFT,8,tag,8,0
                  bind=SUPER+SHIFT,9,tag,9,0

                  # gaps
                  bind=SUPER+SHIFT,x,incgaps,1
                  bind=SUPER+SHIFT,z,incgaps,-1
                  bind=SUPER+SHIFT,r,togglegaps

                  # Mouse Button Bindings
                  # NONE mode key only work in ov mode
                  mousebind=SUPER,btn_left,moveresize,curmove
                  mousebind=SUPER,btn_right,moveresize,curresize
                  mousebind=SUPER+CTRL,btn_right,killclient
                  mousebind=NONE,btn_middle,togglemaximizescreen,0
                  mousebind=NONE,btn_left,toggleoverview,1
                  mousebind=NONE,btn_right,killclient,0

                  # Axis Bindings
                  axisbind=SUPER,UP,viewtoleft_have_client
                  axisbind=SUPER,DOWN,viewtoright_have_client

                  # layer rule
                  layerrule=animation_type_open:zoom,layer_name:rofi
                  layerrule=animation_type_close:zoom,layer_name:rofi

                  # Environment variables
                  env=XCURSOR_SIZE,24
                  env=XCURSOR_THEME,catppuccin-mocha-dark-cursors
                  
                  # Additional environment variables for theming
                  env=GTK_THEME,Catppuccin-Mocha-Standard-Blue-Dark
                  env=ICON_THEME,catppuccin-mocha-blue-standard
                  
                  # Exec commands
                  exec-once=swaybg -i /home/mina/Pictures/wallpaper.jpg
                '';
                autostart_sh = ''
                  # Autostart commands
                  
                  # Notification daemon
                  swaync &

                  # Status bar
                  waybar &

                  # Clipboard manager
                  wl-clipboard &

                  # Wallpaper
                  swaybg -i /home/mina/Pictures/wallpaper.jpg &

                  # Other startup applications can be added here
                '';
 
  };

  # Programs configuration
  programs = {
    home-manager.enable = true;
    # dconf.enable = true;
    # seahorse.enable = true;

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
    kitty = {
      enable = true;
      settings = {
        # Use configured shell based on defaultShell variable
        # shell = "fish";

        font_size = 17;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
        scrollback_lines = 1000;
        enable_audio_bell = false;
        mouse_hide_wait = 60;
        cursor_trail = 1;
        tab_fade = 1;
        active_tab_font_style = "bold";
        inactive_tab_font_style = "bold";
        tab_bar_edge = "top";
        tab_bar_margin_width = 0;
        tab_bar_style = "powerline";
        #tab_bar_style = "fade";
        enabled_layouts = "splits";
      };
      extraConfig = ''
        # Clipboard
        map ctrl+shift+v        paste_from_selection
        map shift+insert        paste_from_selection

        # Scrolling
        map ctrl+shift+up        scroll_line_up
        map ctrl+shift+down      scroll_line_down
        map ctrl+shift+k         scroll_line_up
        map ctrl+shift+j         scroll_line_down
        map ctrl+shift+page_up   scroll_page_up
        map ctrl+shift+page_down scroll_page_down
        map ctrl+shift+home      scroll_home
        map ctrl+shift+end       scroll_end
        map ctrl+shift+h         show_scrollback

        # Window management
        map alt+n               new_os_window
        map alt+w               close_window
        map ctrl+shift+enter    launch --location=hsplit
        map ctrl+shift+s        launch --location=vsplit
        map ctrl+shift+]        next_window
        map ctrl+shift+[        previous_window
        map ctrl+shift+f        move_window_forward
        map ctrl+shift+b        move_window_backward
        map ctrl+shift+`        move_window_to_top
        map ctrl+shift+1        first_window
        map ctrl+shift+2        second_window
        map ctrl+shift+3        third_window
        map ctrl+shift+4        fourth_window
        map ctrl+shift+5        fifth_window
        map ctrl+shift+6        sixth_window
        map ctrl+shift+7        seventh_window
        map ctrl+shift+8        eighth_window
        map ctrl+shift+9        ninth_window # Tab management
        map ctrl+shift+0        tenth_window
        map ctrl+shift+right    next_tab
        map ctrl+shift+left     previous_tab
        map ctrl+shift+t        new_tab
        map ctrl+shift+q        close_tab
        map ctrl+shift+l        next_layout
        map ctrl+shift+.        move_tab_forward
        map ctrl+shift+,        move_tab_backward

        # Miscellaneous
        map ctrl+shift+up      increase_font_size
        map ctrl+shift+down    decrease_font_size
        map ctrl+shift+backspace restore_font_size
      '';
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
    BROWSER = "zen"; # Set in system packages instead
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
    # Additional environment variables for NVIDIA/Wayland compatibility
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    # Keyboard layout settings
    XKB_DEFAULT_LAYOUT = "us,ara";
    XKB_DEFAULT_OPTIONS = "grp:win_space_toggle";
    # Additional variables to help with Wayland keyboard issues
    WAYLAND_KEYBOARD_REPEAT_DELAY = "400";
    WAYLAND_KEYBOARD_REPEAT_RATE = "40";
 };
}
