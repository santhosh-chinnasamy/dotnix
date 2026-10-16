{ pkgs, ... }: {
    users.users.santhosh.extraGroups = [
    "podman"
  ];

  virtualisation.podman = {
  enable = true;
  dockerCompat = true;
  dockerSocket.enable = true;
  defaultNetwork.settings.dns_enabled = true;
};

}