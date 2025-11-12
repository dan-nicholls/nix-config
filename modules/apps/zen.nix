{zenModule, ...}: {
  imports = [zenModule];

  programs.zen-browser = {
    enable = true;
  };
}
