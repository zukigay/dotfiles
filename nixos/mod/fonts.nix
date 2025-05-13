{config, lib, pkgs, ... }:

{
  options = {
    mod-font.enable = 
    	lib.mkEnableOption "switches to noto fonts and installs font-awesome";
  };
  config = lib.mkIf config.mod-font.enable {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome
  ];
  
  fonts = {
  fontconfig = {
  defaultFonts.serif = [ "Noto Serif"  ];
  defaultFonts.sansSerif = [ "Noto Sans"  ];
  defaultFonts.monospace = [ "Noto Sans Mono"  ];
  defaultFonts.emoji = [ "Noto color emoji"  ];
  };
  };





  };
}
