# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    # Define on which hard drive you want to install Grub.
    device = "/dev/sda";
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  virtualisation.docker.enable = true;

  # Set your time zone.
  time.timeZone = "US/Pacific";

  # List packages installed in system profile. To search by name, run:
  environment = {
    shells = [
      "${pkgs.bash}/bin/bash"
      "${pkgs.zsh}/bin/zsh"
    ];
      
    variables = {
      BROWSER = pkgs.lib.mkOverride 0 "chromium";
      EDITOR = pkgs.lib.mkOverride 0 "vim";
    };

    systemPackages = with pkgs; [
      # $ nix-env -qaP | grep wget
      vimHugeX
      zsh
      tmux
      git
      wget
      mosh

      rxvt_unicode-with-plugins
      gnome3.dconf
      awesome
      lua52Packages.vicious
      firefox
      chromium
      dmenu
      xorg.xkill
      mupdf
      redshift
      kicad

      docker
      networkmanagerapplet

      jdk
      clojure
      leiningen
      idea.idea-community
    ];
  };

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = false;
    fonts = [
       pkgs.terminus_font
       pkgs.kochi-substitute-naga10
       pkgs.source-code-pro
    ];
  };

  # List services that you want to enable:
  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;
    redshift = {
      enable = true;
      latitude = "44.0";
      longitude = "120.5";
    };

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "caps:escape";

      # Enable synaptics touchpad
      synaptics = {
        enable = true;
        twoFingerScroll = true;
      };

      # Enable display/window managers
      displayManager.slim.enable = true;
      windowManager = {
        awesome = { 
          enable = true;
          luaModules = [
            pkgs.luaPackages.vicious
          ];
        };
      };
    };
  };

  nixpkgs.config = {
    # Enable unfree packages
    allowUnfree = true;

    # Browser plugins
    chromium = {
      # The free alternatives don't seem to be working?
      enablePepperFlash = true; # Chromium's non-NSAPI alternative to Adobe Flash
      enablePepperPDF = true;
      # Unfree adobe versions:
      #enableAdobeFlash = true;
      #enableAdobePDF = true;
    };
    #virtualbox.enableExtensionPack = true; # Needed? Deprecated?
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.rattboi = {
    home = "/home/rattboi";
    shell = "/run/current-system/sw/bin/zsh";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    isNormalUser = true;
    uid = 1000;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";

}
