{ pkgs, vars, ... }:
{
  # Manage Git configuration declaratively.
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = vars.gitName;
        email = vars.gitEmail;
      };
      init.defaultBranch = "main";
    };
  };
}
