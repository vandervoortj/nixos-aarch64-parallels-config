{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/EFI";
      };
    };
    plymouth.enable = true;
  };

  networking = {
    hostName = "nixos-macbook";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  services = {
    xserver = {
      enable = true;
      layout = "us";
      libinput.enable = true;
      displayManager = {
        gdm = {
          enable = true;
          autoSuspend = false;
        };
        autoLogin = {
          enable = true;
          user = "jom";
        };
      };
      desktopManager.gnome.enable = true;
    };
    printing.enable = true;
    dnsmasq.enable = true;
    openssh.enable = true;
    gnome = {
      chrome-gnome-shell.enable = true;
      gnome-keyring.enable = true;
    };
  };

  sound.enable = true;

  hardware = {
    pulseaudio.enable = true;
    parallels.enable = true;
  };

  users.users.jom = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; 
    packages = with pkgs; [
      chromium
      github-desktop
      gh
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          bbenoist.nix
          matklad.rust-analyzer
          github.copilot
          formulahendry.code-runner
        ];
      })
    ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    vim 
    wget
    cargo
    rustup
    rustc
    rust-analyzer
    git
  ];

  programs = {
    mtr.enable = true;
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      dates = "weekly";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  system = {
    stateVersion = "22.05";
    autoUpgrade = {
      enable = true;
      channel = "nixos-unstable";
      persistent = true;
      allowReboot = true;
    };
  };
}

