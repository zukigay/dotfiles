# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, volare, ... }:
let
  # helloBar = pkgs.hello.overrideAttrs (finalAttrs: previousAttrs: {
  #   pname = previousAttrs.pname + "-bar";
  # });

  # create a custom "vesktopShare" package with a custom "obs-share" patch
  # the patch is from this pull request
  # https://github.com/Vencord/Vesktop/pull/195
  # the patch just allows using any webcam/mic as a screenshare source.
  vesktopShare = pkgs.vesktop.overrideAttrs (finalAttrs: previousAttrs: {
    patches = previousAttrs.patches ++ [ ./vesktop-obs-share.patch ];
  });
  wlroots_0_19-c = pkgs.wlroots_0_18.overrideAttrs (finalAttrs: previousAttrs: {
    version = "0.19";
    # pname = "wlroots";
    src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        # rev = "0.19";
        rev = finalAttrs.version;
        hash = "sha256-I8z50yA/ukvXEC5TksG84+GrQpfC4drBJDRGw0R8RLk=";
    };
    nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
    # nativeBuildInputs = [
        # pkgs.wayland
  #       # unstable.wayland-protocols
  #       # unstable.wayland-utils
    ];

  });

  # sent patch for papersway 2.001 upstream and its been merged yay!
  perlPackages.Apppapersway = pkgs.perlPackages.Apppapersway.overrideAttrs ( rec {
    version = "2.001";
    src = pkgs.fetchurl {
      url = "mirror://cpan/authors/id/S/SP/SPWHITTON/App-papersway-${version}.tar.gz";
      hash = "sha256-Jx8MJdyr/tfumMhuCofQX0r3vWcVuDzfJGpCjq2+Odw=";
    };
  });


  missingSessionFiles = pkgs.stdenv.mkDerivation (finalAttrs: with pkgs; { 
    pname = "missingSessionFiles";
    version = "0.1";
    passthru.providedSessions = [ "cagebreak" "dwlsrc" ];
    unpackPhase = "true";
    installPhase = let
        cagebreakSession = ''
        [Desktop Entry]
        Name=cagebreak
        Comment=a neat compositor
        Exec=cagebreak
        Type=Application
        '';
        dwlsrcSession = ''
        [Desktop Entry]
        Name=dwlsrc
        Comment=dwl run from my src dir for convence
        Exec=env XDG_CURRENT_DESKTOP=dwl ./src/dwl/dwl -s ./src/dwl/startup
        Type=Application
        '';

      in
        ''
    mkdir -p $out/share/wayland-sessions
    echo "${cagebreakSession}" > $out/share/wayland-sessions/cagebreak.desktop
    echo "${dwlsrcSession}" > $out/share/wayland-sessions/dwlsrc.desktop
        '';
        });


  cwcwm = pkgs.stdenv.mkDerivation (finalAttrs: with pkgs; {
      pname = "cwcwm";
      version = "0.1";
      passthru.providedSessions = [ "cwc" ];
    
      src = fetchFromGitHub {
        owner = "Cudiph";
        repo = "cwcwm";
        rev = "eb0eb25ebefd76ee8275286a675ccd91f73219d3";
        hash = "sha256-+G82XlyZluGk60mTkQQ48qQZ1dC1MDw4W3M2kTH6qeA=";
      };
      patches = [ ./src/cwcwm-drm-fourcc-include.patch ];
      # src = ./src/cwcwm;
      # buildInputs = [
      #   meson ninja pkg-config wayland wayland-scanner git pkg-config hyprcursor cairo
      #   libxkbcommon libinput xxHash luajit python3
      #   libdrm xorg.libX11 xorg.xcbutilwm libevdev libinput
      #   cmake
      #    wayland-protocols
      #    wlroots_0_19_git
      # ];
      nativeBuildInputs =  [
        meson ninja pkg-config wayland wayland-scanner git pkg-config hyprcursor cairo
        libxkbcommon libinput xxHash luajit python3
        libdrm xorg.libX11 xorg.xcbutilwm libevdev libinput
        cmake
         wayland-protocols
         wlroots_0_19-c
            ];
        # cmakeFlags = [ "-DCWC_DATADIR=\"/bin\"" ];
    installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    mkdir -p $out/usr/share/wayland-sessions
    mkdir -p $out/usr/
    mkdir -p $out/usr/share/cwc
    # ls --recursive ./../
    mv ./../lib $out/usr/share/cwc
    mv ./../defconfig $out/usr/share/cwc
    mv ./../cwc.desktop $out/usr/share/wayland-sessions
    mv ./../include $out/usr/include/
    mv ./src/cwc $out/bin
    mv ./../build/cwctl/cwctl $out/bin
    # mv ./src/include/cwc $out/usr/include/
    '';
    });

  cdwlb = pkgs.dwlb.override {
    configH = ./src/dwlb/config.h;
  };
  btop = pkgs.btop.override {
    cudaSupport = true;
  };
  # mangohud = pkgs.mangohud.override {
  #   gamescopeSupport = true;
  # };
  # cwcwm = import ./cpkgs/cwcwm.nix;


  # qtile-unwrapped = pkgs.qtile-unwrapped.overrideAttrs (oldAttrs: {
  #   nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
        # pkgs.wayland
        # pkgs.wayland-scanner
    # ];
  #   src = pkgs.fetchFromGitHub {
  #       owner = "jwijenbergh";
  #       repo = "qtile";
  #       rev = "6fbe6c58af5ceb2bc2287ce209bc48b531ba38af";
  #       hash = "sha256-CVDsTqlRebNXCZWKSbLRUL8YJLg81FJ8R6EDgZYOwho=";
  #   };
  # });


  cdwlb-tray = cdwlb.overrideAttrs (oldAttrs: {
    src = pkgs.fetchFromGitHub {
        owner = "vetu104";
        repo = "dwlb";
        rev = "f19f1105ed8220e81fa89884fcba1a841175242f";
        hash = "sha256-sWXTxLHk555PhC9qBTPE84/PoEFe8B1HHwXtbkCz9Mk=";
    };
    # src = ./src/dwlb-sys;
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
        pkgs.gtk4-layer-shell
        pkgs.gtk4
    ];
    # patches = oldAttrs.patches ++ [ ./src/dwlb-systray-nixos.patch ];
    # patches = [ ./src/dwlb-systray-nixos.patch ];
  });



  cdwlraw = pkgs.dwl.overrideAttrs (oldAttrs: {
    name = "cdwl";
    # src = ./src/dwl;
    passthru.providedSessions = [ "dwl" ];
    patches = [ 
    ./src/dwl-p/warpcursor-nix.patch
    ./src/dwl-p/attachbottom.patch
    ./src/dwl-p/namedscratchpads.patch
    # ./src/dwl-p/gaps.patch
    # padsafe is a modified gaps patch to play nice with the namedscratchpads patch
    ./src/dwl-p/gaps-padsafe.patch
    ./src/dwl-p/xwayland-handle-minimize.patch
    ./src/dwl-p/autostart-0.7.patch
    ./src/dwl-p/push-0.7.patch
    ./src/dwl-p/alwayscenter.patch
    ./src/dwl-p/cursorsize30.patch
    ./src/dwl-p/chainkeys-noconfig.patch
    # ./src/dwl-p/dwlb.patch
    ./src/dwl-p/dwlb+wlrestart.patch
    ./src/dwl-p/wayland-socket-handover.patch
    ./src/dwl-p/restore-monitor.patch


    # ./src/dwl-p/hot-reload-0.7.patch
    # ./src/dwl-p/sedfix.patch
    ];
  });
  cdwl = cdwlraw.override {
    configH = ./src/dwl/config.h;
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./mod/bundle.nix
      ./externalDrives.nix
    ];
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.consoleMode = "max";

  system.rebuild.enableNg = true;

  services.udisks2.enable = true;

  # modules
  mod-font.enable = true;
  mod-pathenv.enable = false;
  mod-steam.enable = true;
  mod-wayenv.enable = true;
  mod-theme.enable = true;
  mod-waynvidiaenv.enable = true;
  mod-xdgenv.enable = true;
  mod-scripts.enable = true;
  mod-keyboardfix.enable = true;
  mod-hyprPlugin.enable = true;
  mod-hyprPluginDarkWin.enable = true;
  mod-heavyEmu.enable = true;
  mod-riverwm.enable = true;
  mod-localeTime.enable = true;
  # mod-scroll.enable = true;
  mod-intelNoTurbo.enable = true;
  # mod-volare.enable = true;
  mod-nonSteam.enable = true;

  mod-vr.enable = true;

  programs.sway.enable = true;
  programs.sway.extraOptions = [
  "--unsupported-gpu"
  ];
  # services.desktopManager.cosmic.enable = true;


  networking.hostName = "zuki"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.wireless.iwd.enable = true;
  # because of my wifi card i need this
  # hardware.enableRedistributableFirmware = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.networkmanager.enable = false; # disabled this because i both don't use it and when testing cosmic it was fucking with my networking.
  hardware.bluetooth.enable = true;

  # environment.variables = {
  environment.sessionVariables = {
    NIXOS_CONFIG="/home/zuki/.config/nixos/configuration.nix";
    FLAKE="/home/zuki/.config/nixos";
    QT_WAYLAND_RECONNECT="1";
  };

  # Set your time zone.
  nixpkgs.config.allowUnfree = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [nvidia-vaapi-driver];
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true; # Set to false to use the proprietary kernel module
  # hardware.nvidia.nvidiaPersistenced = true;


  

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;
  services.flatpak.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  services.mullvad-vpn.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zuki = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd"]; # Enable ‘sudo’ for the user.
    # groups my gentoo instal user is in
    # lp wheel cron audio video libvirt users pipewire zuki
    packages = (with pkgs; [
    # cwcwm
    # wlroots_0_19_git
    aseprite
    arc-theme
    file-roller
    cosmic-icons
    kitty
    imv
    foot
    tmux
    mpv
    # pcmanfm
    pcmanfm-qt
    # fuzzel
    keepassxc
    odin
    qbittorrent

    # pkgs-stable.odin

    # lite emualtors
    retroarch
    mgba
    melonDS

    perlPackages.Apppapersway

    ranger
    # for ranger
    atool
    unzip

    lazygit
    fastfetch

    keepassxc

    rnnoise-plugin

    bluetuith
    ncpamixer

    btop
    nvtopPackages.full
    nix-search

    wl-clipboard
    thunderbird
    gammastep

    obs-studio
    obs-studio-plugins.obs-vkcapture

    gallery-dl

    tiled

    # qalculate-gtk
    qalculate-qt

    # split into video editing module or even "big package" module to not slow down new installs and such
    kdePackages.kdenlive
    davinci-resolve
    ffmpeg
    gimp3

    ripdrag

    xorg.xeyes

    mullvad-vpn # turns out the gui mullvad app is not included in mullvad.enable good to know.
    
    playerctl # used in river and dwl for media control

    wev

    # itch

    syncthing

    xwayland-satellite # used by niri because they didn't want to deal with xwayland

    # vesktop

    # waybar
    ]) ++ ([vesktopShare cdwl cdwlb ]);
  };

  services.displayManager.ly.enable = true;
  services.displayManager.ly.settings = { animation="doom"; };
  services.displayManager.sessionPackages = [ cdwl missingSessionFiles ];


  programs.firefox.enable = true;
  # services.xserver.windowManager.qtile.enable = true;
  # services.xserver.windowManager.qtile.package = qtileflake.packages.${pkgs.stdenv.hostPlatform.system}.qtile;
  # services.xserver.windowManager.qtile.package = qtile-unwrapped;
  # services.xserver.windowManager.qtile.package
  # programs.niri.enable = true;
  programs.hyprland.enable = true;
  programs.hyprland.plugins = [
    # pkgs.hyprlandPlugins.hyprbars
    # hypr-darkwindow.packages.${pkgs.system}.Hypr-DarkWindow
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    kakoune
    wget
    git
    wl-restart
    cagebreak
  ];
  programs.direnv.enable = true;
  # programs.direnv = {
  #   package = pkgs.direnv;
  #   silent = false;
  #   loadInNixShell = true;
  #   direnvrcExtra = "";
  #   nix-direnv = {
  #     enable = true;
  #     package = pkgs.nix-direnv;
  #   };
  #   };

 

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

