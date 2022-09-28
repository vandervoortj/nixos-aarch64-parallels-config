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

  powerManagement.enable = false;

  #disabled parallels print service as it was endlessly executing lpstat and timing out
  #disable printer sharing in parallels options and switch shared network to bridged to use network
  #printers
  systemd.services.prlshprint.enable = pkgs.lib.mkForce false;

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
    };
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
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
      gnome-settings-daemon.enable = true;
    };
  };

  sound.enable = true;

  hardware = {
    pulseaudio.enable = true;
    parallels.enable = true;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  users = {
    defaultUserShell = pkgs.fish;
    users.jom = {
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
    };
  };

  environment = {
    shells = [ pkgs.fish ];
    gnome.excludePackages = [ pkgs.gnome-tour ];
    systemPackages = with pkgs; [
      vim 
      wget
      cargo
      rustup
      rustc
      rust-analyzer
      git
      gnomeExtensions.material-shell
      nodejs-16_x
    ];
  };

  programs = {
    mtr.enable = true;
    fish.enable = true;
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
      configure = {
        customRC = ''
          set undofile
          set undodir=~/.vim/undodir
        '';
        packages.nix.start = with pkgs.vimPlugins; [ 
          vim-nix 
          coc-nvim
          coc-rust-analyzer
          copilot-vim 
          coc-git
          coc-highlight
          rainbow
          vim-fugitive
        ];
      };
    };
    starship = {
      enable = true;
      settings = {
        "add_newline" = false;
        "format" = "$all";
        "scan_timeout" = 30;
        "username" = {
          "format" = "[$user]($style)";
          "style_user" = "bold green";
          "show_always" = true;
          "style_root" = "bold red";
        };
      };
    };
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

