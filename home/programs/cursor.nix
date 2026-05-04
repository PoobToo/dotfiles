{ pkgs, lib, ... }:

let
  googledot-black = pkgs.stdenvNoCC.mkDerivation {
    pname = "googledot-black-cursor";
    version = "2.0.0";

    src = pkgs.fetchurl {
      url = "https://github.com/ful1e5/Google_Cursor/releases/download/v2.0.0/GoogleDot-Black.tar.gz";
      sha256 = "1qq0pnpzqi582f8d6rixiyc594chmz2dp354l4k8dh7smg64vn7r";
    };

    installPhase = ''
      mkdir -p $out/share/icons
      cp -r . $out/share/icons/GoogleDot-Black
    '';

    meta = with lib; {
      description = "GoogleDot Black cursor theme";
      homepage = "https://github.com/ful1e5/Google_Cursor";
      license = licenses.gpl3Only;
      platforms = platforms.linux;
    };
  };
in
{
  home.pointerCursor = lib.mkForce {
    name = "GoogleDot-Black";
    package = googledot-black;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
