{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/EFI";
  boot.plymouth.enable = true;

  networking.hostName = "nixos-macbook"; 
  networking.networkmanager.enable = true;  

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  services.xserver.enable = true;
  services.xserver.layout = "us";

  services.dnsmasq.enable = true;

  services.printing.enable = true;
  services.gnome.chrome-gnome-shell.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "jom";
  };
  services.xserver.displayManager.gdm.autoSuspend = false;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.parallels.enable = true;

  services.xserver.libinput.enable = true;

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

  programs.mtr.enable = true;
  programs.fish.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";
  nix.gc.dates = "weekly";
  nix.optimise.automatic = true;
  nix.optimise.dates = [ 
                          "weekly"
                       ];

  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = "nixos-unstable";
  system.autoUpgrade.persistent = true;
  system.autoUpgrade.allowReboot = true;
  system.stateVersion = "22.05"; 
}

