{config, lib, pkgs, ...}:
let
# {
  Hypr-DarkWindow = pkgs.gcc14Stdenv.mkDerivation {
    pname = "Hypr-DarkWindow";
    version = "3.0.1";
    src = pkgs.fetchFromGitHub {
        owner = "micha4w";
        repo = "Hypr-DarkWindow";
        rev = "9d541dbd1e96d1dab887d9b6f10cbefd6476d104";
        hash = "sha256-IFfMnkQZeWuRrMxbIDfVAcbAhWmLqMSno64+NnXMIAE=";
    };
    # src = nix-filter.lib {
    #   root = ./.;
    #   include = [
    #     "src"
    #     ./Makefile
    #   ];
    # };

    nativeBuildInputs = with pkgs; [ pkg-config ];
    buildInputs = [pkgs.hyprland] ++ pkgs.hyprland.buildInputs;

    installPhase = ''
      mkdir -p $out/lib
      install ./out/hypr-darkwindow.so $out/lib/libHypr-DarkWindow.so
    '';

    meta = with pkgs.lib; {
      homepage = "https://github.com/micha4w/Hypr-DarkWindow";
      description = "Invert the colors of specific Windows";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  # default = Hypr-DarkWindow;
  };
# }
in
{
  options = {
    mod-hyprPluginDarkWin.enable = 
    	lib.mkEnableOption "switches to noto fonts and installs font-awesome";
  };
  config = lib.mkIf config.mod-hyprPluginDarkWin.enable {
    programs.hyprland.plugins = [
    Hypr-DarkWindow
    ];
  };
}
