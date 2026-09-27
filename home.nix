{ config, pkgs, spicetify-nix, ... }:

let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [
	  spicetify-nix.homeManagerModules.default
  ];

  # Install Home Manager
  programs.home-manager.enable = true;

  # Allow access to the GPU (needs to be expanded for NVidia: https://nix-community.github.io/home-manager/usage/gpu-non-nixos.html#sec-usage-gpu-non-nixos)
  targets.genericLinux.enable = true;

  ## BASIC SETTINGS
  home.username = "jamief";
  home.homeDirectory = "/home/jamief";
  home.stateVersion="26.05";

  ## SYMLINKS
  home.file = {
    ### Dotfiles ###
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/.dotfiles/.zshrc;
    ".zshenv".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/.dotfiles/.zshenv;
    ".zsh".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/.dotfiles/.zsh;
    ".vimrc".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/.dotfiles/.vimrc;
    ".latexmkrc".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/.dotfiles/.latexmkrc;
    ".dir_colors".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/.dotfiles/.dir_colors;
    ".config/alacritty".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/.dotfiles/.config/alacritty;
    ".config/albert".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/.dotfiles/.config/albert;
    ".config/cosmic".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/.dotfiles/.config/cosmic; # Config for COSMIC DE – comment out/delete if using another DE
    ### AppImages ###
    ".local/bin/whatsapp.AppImage".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/Dropbox/appimages/whatsapp/whatsapp.AppImage;
    ".local/share/whatsapp/whatsapp.ico".source = config.lib.file.mkOutOfStoreSymlink /home/jamief/Dropbox/appimages/whatsapp/whatsapp.ico;
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
  # List of packages without their own modules or where I'm not using the config options of the module
  home.packages = with pkgs; [
    zsh
    vim
    alacritty
    xclip
    git
    wl-clipboard
    tree
    tldr
    # brave                   # loaded via module below
    discord
    libreoffice
    # texliveFull
    # dropbox
    albert
    omnissa-horizon-client
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
    emacs-pgtk                 # native Wayland version 
    fd
    ripgrep
    pandoc                     # for markdown compiling
    shellcheck
    #grip                      # deprecated
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
    package = pkgs.brave;
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

  # Temporary desktop entry because of COSMIC bug not throwing away %F: https://github.com/pop-os/cosmic-launcher/issues/461
  xdg.desktopEntries.emacsclient = {
    name = "Emacs (Client)";
    genericName = "Text Editor";
    comment = "Edit text";
    exec = "emacsclient --alternate-editor= --create-frame --no-wait %F";
    icon = "emacs";
    terminal = false;
    categories = [ "Development" "TextEditor" ];
    startupNotify = true;
    settings = {
      StartupWMClass = "Emacs";
      Keywords = "emacsclient;";
    };
    mimeType = [
      "text/english"
      "text/plain"
      "text/x-makefile"
      "text/x-c++hdr"
      "text/x-c++src"
      "text/x-chdr"
      "text/x-csrc"
      "text/x-java"
      "text/x-moc"
      "text/x-pascal"
      "text/x-tcl"
      "text/x-tex"
      "application/x-shellscript"
      "text/x-c"
      "text/x-c++"
      "x-scheme-handler/org-protocol"
    ];
  };

  # Firefox
  programs.firefox.enable = true;

  # Install Dropbox and run the daemon
  # services.dropbox.enable = true;

  # Install and prettify Spotify
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      shuffle
      hidePodcasts
      popupLyrics
      #betterGenres # deprecated?
    ];
    theme = spicePkgs.themes.sleek;
    colorScheme = "Nord";
  };

  # Desktop entries
  xdg.desktopEntries = {
    whatsapp = {
      name = "WhatsApp";
      type = "Application";
      exec = "/home/jamief/.local/bin/whatsapp.AppImage";
      icon = "/home/jamief/.local/share/whatsapp/whatsapp.ico";
      terminal = false;
      categories = [ "Network" "InstantMessaging" ];
      settings = {
        StartupWMClass = "whatsapp-desktop-linux";
      };
    };
  };
}
