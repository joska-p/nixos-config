{ pkgs, ... }:
{
  # Manage Git configuration declaratively.
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "joska";
        email = "jpotin@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };
}
