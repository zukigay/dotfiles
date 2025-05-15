# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
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

  cdwl = pkgs.dwl.overrideAttrs (oldAttrs: {
    name = "cdwl";
    src = ./src/dwl;
    passthru.providedSessions = [ "dwl" ];
    patches = [ 
    ./src/dwl-p/warpcursor-nix.patch
    ./src/dwl-p/attachbottom.patch
    ./src/dwl-p/namedscratchpads.patch
    # ./src/dwl-p/gaps.patch
    # padsafe is a modified gaps patch to play nice with the namedscratchpads patch
    ./src/dwl-p/gaps-padsafe.patch
    ./src/dwl-p/xwayland-handle-minimize.patch
    # ./src/dwl-p/hot-reload-0.7.patch
    # ./src/dwl-p/sedfix.patch
    ];
  });
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

  # modules
  mod-font.enable = true;
  mod-steam.enable = true;
  mod-wayenv.enable = true;
  mod-waynvidiaenv.enable = true;

  networking.hostName = "zuki"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.wireless.iwd.enable = true;
  # because of my wifi card i need this
  # hardware.enableRedistributableFirmware = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  hardware.bluetooth.enable = true;

  # environment.variables = {
  environment.sessionVariables = {
    NIXOS_CONFIG="/home/zuki/.config/nixos/configuration.nix";
  };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";
  nixpkgs.config.allowUnfree = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zuki = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    # groups my gentoo instal user is in
    # lp wheel cron audio video libvirt users pipewire zuki
    packages = (with pkgs; [
    arc-theme
    kitty
    mpv
    # fuzzel
    keepassxc
    ranger
    lazygit
    fastfetch
    keepassxc
    rnnoise-plugin

    bluetuith
    ncpamixer
    adwaita-icon-theme

    wl-clipboard
    thunderbird

    # vesktop

    # waybar
    ]) ++ ([vesktopShare cdwl]);
  };

  services.displayManager.ly.enable = true;
  services.displayManager.sessionPackages = [ cdwl ];

  programs.firefox.enable = true;
  programs.river.enable = true;
  programs.river.extraPackages = with pkgs; [ 
    kitty 
    waybar 
    fuzzel 
    lua5_3 
    river-luatile 
    hyprpaper 
    slurp 
    grim 

    # xrandr for setting a monitor as --primary
    # so that steam games won't cap the res
    # at the lowist active monitor.
    xorg.xrandr

    # for notifcations
    dunst
    libnotify

    # to set monitors up
    wlr-randr
    kanshi
    jq

    qt6ct
    libsForQt5.qt5ct
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    kakoune
    wget
    git
  ];

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

