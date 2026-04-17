
{ pkgs, ... }: {
  # Allow unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "_11password"
    "_1password-gui"
  ];

  # Enable 1Password (CLI) and 1Password GUI
  programs._1password.enable = true;
  programs._1password1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "santhosh" ]; # Required for GUI
  };
}
