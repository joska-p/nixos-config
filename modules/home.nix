{ pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "muratha";
  home.homeDirectory = "/home/muratha";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "25.11"; # Match this with your NixOS version

  # The home.packages option allows you to install user-specific software.
  # These will only be available to your user, keeping the system path clean.
  home.packages = with pkgs; [
    # --- Text Editors & IDEs ---
    nixd # Language server for Nix (autocomplete)

    # --- Development & Build Tools ---
    cmake
    gcc
    nodejs
    nixfmt

    # --- Multimedia & Audio ---
    vlc
    easyeffects # Advanced audio manipulation for PipeWire

    # --- Utilities ---
    bat # Improved cat command
    uget # Download manager
    kdiff3 # File comparison tool

    # --- Desktop Apps ---
    flatpak
    kdePackages.kcalc
    kdePackages.kolourpaint

    # --- Gaming & Windows Compatibility ---
    wine
    winetricks
    protonplus
  ];

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

  # Your Zsh configuration, moved from the system level.
  # Home Manager is much better at managing shell configs.
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # --- General ---
      ll = "ls -l";
      la = "ls -lah"; # Show all files with detailed info and human-readable sizes
      ".." = "cd ..";
      "..." = "cd ../..";
      v = "vim";
      z = "zed";

      # --- NixOS Management ---
      rebuild = "sudo nixos-rebuild switch";
      update = "sudo nixos-rebuild switch --upgrade";
      nix-clean = "sudo nix-collect-garbage -d"; # Deep clean old generations
      nix-list = "nix-env --list-generations --profile /nix/var/nix/profiles/system";

      # --- Git ---
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
    };

    oh-my-zsh = {
      enable = true;
      theme = "refined";
    };
  };

  programs.zed-editor = {
    enable = true;
    userSettings = {
      theme = "Gruvbox Dark";
      ui_font_size = 16;
      buffer_font_family = "JetBrainsMono Nerd Font";
      autosave = "on_focus_change";
      vim_mode = false;
      telemetry = {
        metrics = false;
      };
      languages = {
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
        };
      };
    };
  };

  programs.gemini-cli = {
    enable = true;
    settings = {
      context = {
        loadMemoryFromIncludeDirectories = true;
      };
      general = {
        preferredEditor = "zeditor";
        previewFeatures = true;
        vimMode = true;
      };
      ide = {
        enabled = true;
      };
      privacy = {
        usageStatisticsEnabled = false;
      };
      security = {
        auth = {
          selectedType = "oauth-personal";
        };
      };
      tools = {
        autoAccept = false;
      };
      ui = {
        theme = "Default";
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
