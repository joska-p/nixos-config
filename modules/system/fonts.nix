{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono # Developer font with many icons
    noto-fonts # Standard Google fonts for all languages
    noto-fonts-cjk-sans # CJK character support
    noto-fonts-color-emoji # Color emoji support
    liberation_ttf # Open-source versions of standard fonts
    fira-code # Popular coding font with ligatures
    fira-code-symbols # Extra symbols for Fira Code
    mplus-outline-fonts.githubRelease # Versatile Japanese font
    dina-font # Crisp bitmapped coding font
    proggyfonts # Small coding fonts
    vista-fonts # Microsoft fonts from the Vista era
    corefonts # Microsoft core web fonts (Arial, etc.)
  ];
}
