# Edit this configuration file to define what should be installed on your system.  Help is available in the
# configuration.nix(5) man page and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, pkgs, ... }:

let
  settings = import ./settings.nix;
in {
  system.stateVersion = "21.05";

  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnfree = true;
      packageOverrides = pkgs: { steam = pkgs.steam.override { extraPkgs = pkgs: [ pkgs.pipewire.lib ]; }; };

    };
  };
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  # Use the GRUB2 boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      grub = {
        enable = true;
        copyKernels = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        fsIdentifier = "uuid";
        version = 2;
        gfxmodeEfi = "auto";
        device = "nodev";
        useOSProber = true;
      };
      efi = {
        canTouchEfiVariables = false;
      };
    };
  };

  networking = {
    hostName = "cascade"; # Define your hostname.
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.enp5s0.useDHCP = true;
    interfaces.enp6s0.useDHCP = true;
    interfaces.wlp7s0.useDHCP = true;
    firewall.allowedTCPPorts = [ 24800 ];
  };

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here. Per-interface useDHCP will be
  # mandatory in the future, so this generated config replicates the default behaviour.

  # Configure network proxy if necessary networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties. i18n.defaultLocale = "en_US.UTF-8"; console = { font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    dbus = {
      enable = true;

      packages = with pkgs; [
        gnome3.dconf
      ];
    };

    avahi = {
      enable = true;
      nssmdns = true;
    };

    xserver = {
      enable = true;
      screenSection = ''
        Option         "metamodes" "5120x1440_120 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
      '';
      displayManager.lightdm.enable = true;
      windowManager.i3.enable = true;
      videoDrivers = [ "nvidia" ];
      layout = "us";
      xkbOptions = "caps:escape";
    };

    pcscd = {
      enable = true;
    };

    udev = {
      packages = [ pkgs.yubikey-personalization ];
      # Rules for streamdeck being accessible by libusb/normal users
      extraRules = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="0060", MODE="0660", GROUP="wheel"
        SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="0063", MODE="0660", GROUP="wheel"
        SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="006c", MODE="0660", GROUP="wheel"
        SUBSYSTEM=="usb", ATTR{idVendor}=="0fd9", ATTR{idProduct}=="006d", MODE="0660", GROUP="wheel"
        SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6001", MODE="0660", GROUP="wheel"
        '';
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql96;
      enableTCPIP = true;
    };

    redis.enable = true;
  };

  hardware = {
    opengl = {
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
      driSupport = true;
      driSupport32Bit = true;
    };
  };


  # Configure keymap in X11

  # Enable CUPS to print documents. services.printing.enable = true;

  # Enable sound.
  sound.enable = true;

  # Enable touchpad support (enabled default in most desktopManager). services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    root = {
      hashedPassword = settings.user.hashedPassword;
    };
    ${settings.user.username} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "video"
        "docker"
        "networkmanager"
      ];
      hashedPassword = settings.user.hashedPassword;
    };
  };

  xdg.mime.enable = true;

  home-manager.users.root = { pkgs, ... }: {
    imports = [
      ./home/terminal/basic.nix
    ];
  };

  home-manager.users.${settings.user.username} = { ... }: {
    nixpkgs = {
      config = {
        allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
          "1password"
          "1password-gui"
          "discord"
          "dropbox"
          "firefox-bin"
          "firefox-release-bin-unwrapped"
          "vscode-extension-ms-vscode-cpptools"
          "ruby-mine"
          "postman"
          "signal-desktop"
          "slack"
          "spotify"
          "spotify-unwrapped"
          "steam"
          "steam-original"
          "steam-runtime"
          "vscode"
          "zoom"
        ];
      };
    };

    imports = [
      ./home/terminal/basic.nix
      ./home/desktop/basic.nix
    ];
  };

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
    exfat
    ethtool
    glxinfo
    lm_sensors
    mkpasswd
    nfs-utils
    pciutils
    usbutils
  ] ++ [
    chromium
    firefox
    libreoffice-fresh
    masterpdfeditor
    pavucontrol
  ];

  virtualisation.docker = {
    enable = true;

    autoPrune = {
      enable = true;
    };
  };

  fonts = {
    fonts = with pkgs; [
      source-code-pro
      source-sans-pro
      source-serif-pro
      fira-code
      jetbrains-mono
      twemoji-color-font
      libre-baskerville
      font-awesome (
        nerdfonts.override {
          fonts = [ "FiraCode"];
        }
        )
      ];

      fontconfig = {
        defaultFonts = {
          monospace = [ "Source Code Pro" ];
          sansSerif = [ "Source Sans Pro" ];
          serif     = [ "Source Serif Pro" ];
        };
      };
    };

  }

