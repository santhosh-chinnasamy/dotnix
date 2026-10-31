{
  ls = "eza";
  cat = "bat";
  src = "source ~/.zshrc";
  hg = "history | rg $1";

  ## git
  /*
    g = "git";
    gst = "git status";
    gl = "git pull";
    gp = "git push";
    ga = "git add";
    gc = "git commit";
    gd = "git diff";
  */
  lg = "lazygit";

  # flake repo (same path on ThinkPad and Mac)
  nd = "cd ~/.config/dotnix";
  nrt = "cd ~/.config/dotnix && nvim .";

  # NixOS (thinkpad)
  nts = "cd ~/.config/dotnix && sudo nixos-rebuild switch --flake .#thinkpad";
  ntb = "cd ~/.config/dotnix && sudo nixos-rebuild build --flake .#thinkpad";
  ntt = "cd ~/.config/dotnix && sudo nixos-rebuild test --flake .#thinkpad";

  # nix-darwin (work-mac)
  dd = "cd ~/.config/dotnix";
  ds = "cd ~/.config/dotnix && sudo darwin-rebuild switch --flake .#work-mac";
  db = "cd ~/.config/dotnix && sudo darwin-rebuild build --flake .#work-mac";

  # vim
  v = "nvim .";
  vi = "nvim";
  nv = "nvim";

  # package managers
  y = "yarn";
  nr = "npm run";
  nrd = "npm run start:dev";
  nt = "npm run test";
  nrts = "npm test -- $(git diff --name-only --cached | grep -E '\\.(test|spec)\\.(js|ts)x?$')";
}
