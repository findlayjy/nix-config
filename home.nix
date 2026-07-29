{ config, pkgs, spicetify-nix, ... }:

let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [
	  spicetify-nix.homeManagerModules.default
  ];
  
  ## BASIC SETTINGS
  home.username = "jamief";
  home.homeDirectory = "/home/jamief";
  home.stateVersion="26.05";

  ## Setting zsh as the default shell
  programs.zsh.enable = true;
  users.users.jamief.shell = pkgs.zsh;
  
  ## SYMLINKING DOTFILES
  home.file = {
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/.dotfiles/.zshrc;
    ".zshenv".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/.dotfiles/.zshenv;
    ".zsh".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/.dotfiles/.zsh;
    ".vimrc".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/.dotfiles/.vimrc;
    ".latexmkrc".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/.dotfiles/.latexmkrc;
    ".dir_colors".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/.dotfiles/.dir_colors;
    ".config/alacritty".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/.dotfiles/.config/alacritty;
    ".config/cosmic".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/.dotfiles/.config/cosmic; # Config for COSMIC DE – comment out/delete if using another DE
  };

  # Setting some default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Browser  
      "text/html" = "brave-browser.desktop"; 
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/chrome" = "brave-browser.desktop";
      "application/x-extension-htm" = "brave-browser.desktop";
      "application/x-extension-html" = "brave-browser.desktop";
      "application/x-extension-shtml" = "brave-browser.desktop";
      "application/xhtml+xml" = "brave-browser.desktop";
      "application/x-extension-xhtml" = "brave-browser.desktop";
      "application/x-extension-xht" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
    };
  };

  # Allow Home Manager to update the font cache
  fonts.fontconfig.enable = true;
  
  ## USER PACKAGES
  # List of packages without their own modules
  home.packages = with pkgs; [
    # zsh
    vim
    alacritty
    git
    wl-clipboard
    tree
    tldr
    brave
    discord
    # texliveFull
    ## Python
    python3
    python3Packages.isort
    python3Packages.pytest
    pipenv
    ## Haskell
    haskellPackages.ghc
    haskellPackages.cabal-install
    haskellPackages.hoogle
    haskell-language-server
    ## Doom emacs requirements
    fd
    ripgrep
    pandoc                     # for markdown compiling
    shellcheck
    grip
    nixfmt                     # formatting for nix
    zig                        # for building ghostel
    ## Fonts
    nerd-fonts.jetbrains-mono  # JetBrains Mono
    nerd-fonts.symbols-only
    fira                       # Fira Sans
    symbola
    source-sans
  ];

  # Extensions for Chromium browsers like Brave (IDs from Chrome Web Store URL)
  programs.chromium = {
    enable = true;
    extensions = [
      "fdjamakpfbbddfjaooikfcpapjohcfmg" # Dashlane
      "aapbdbdomjkkjkaonfhkkikfgjllcleb" # Google Translate
    ];
  };
  
  # Git settings
  programs.git = {
    enable = true;
    settings = {
      user.name = "Jamie Findlay";
      user.email = "jy.findlay@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  # Emacs
  services.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    defaultEditor = true;
  };

  # Firefox
  programs.firefox.enable = true;

  # Install Dropbox and run the daemon
  services.dropbox.enable = true;

  # Install and prettify Spotify
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      shuffle
      hidePodcasts
      popupLyrics
      betterGenres
    ];
    theme = spicePkgs.themes.sleek;
    colorScheme = "Nord";
  };

}
