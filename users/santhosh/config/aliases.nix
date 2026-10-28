{
  ls = "eza";
  cat = "bat";
  src = "source ~/.zshrc";
  hg = "history | rg $1";

  ## git
  g = "git";
  gst = "git status";
  gl = "git pull";
  gp = "git push";
  ga = "git add";
  gc = "git commit";
  gd = "git diff";
  lg = "lazygit";

  # nix
  d = "cd /etc/nixos-config/";
  dv = "cd /etc/nixos-config/ && nvim .";

  # nix-darwin
  nd = "cd ~/.config/dotnix";
  nds = "cd ~/.config/dotnix && sudo darwin-rebuild switch --flake .#work-mac";

  # vim
  v = "nvim .";
  vi = "nvim";
  nv = "nvim";

  # package managers
  y = "yarn";
  nr = "npm run";
  nrd = "npm run start:dev";
  nrt = "npm run test";
  nrts = "npm test -- $(git diff --name-only --cached | grep -E '\\.(test|spec)\\.(js|ts)x?$')";
}
