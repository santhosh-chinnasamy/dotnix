{ pkgs, ... }: {
  # Standard groups for embedded dev
  users.users.santhosh.extraGroups = [
    "dialout"
    "plugdev"
  ];

  services.udev.extraRules = ''
    # CP210x USB to UART Bridge
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", MODE="0660", GROUP="dialout", TAG+="uaccess"

    # CH340 / CH341 USB to UART Bridge
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1a86", MODE="0660", GROUP="dialout", TAG+="uaccess"
  '';
}
