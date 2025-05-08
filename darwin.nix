{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.home-manager
  ];

  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "uninstall";
    };

    casks = [
      "1password"
      "betterdisplay"
      "discord"
      "eloston-chromium"
      "firefox@developer-edition"
      "font-maple-mono"
      "ghostty"
      "orbstack"
      "rectangle"
      "spotify"
      "tailscale"
      "whatsapp"
      "zed@preview"
    ];
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
