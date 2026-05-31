{ stdenv
, lib
, fetchurl
, dpkg
, autoPatchelfHook
, alsa-lib
, freetype
, libGL
, curl
, xorg
}:

stdenv.mkDerivation rec {
  pname = "chow-tape-model";
  version = "2.11.4";

  src = fetchurl {
    url = "https://github.com/jatinchowdhury18/AnalogTapeModel/releases/download/v${version}/ChowTapeModel-Linux-x64-${version}.deb";
    hash = "sha256-caquHEVKyDrBaySNTMmcEr9tEUUqhzdvy2seeQYOOlw=";
  };

  nativeBuildInputs = [ dpkg autoPatchelfHook ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    alsa-lib
    freetype
    libGL
    curl
    xorg.libX11
    xorg.libXext
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
  ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/lv2 $out/lib/vst3 $out/lib/clap
    cp -r usr/bin/CHOWTapeModel $out/bin/
    cp -r usr/lib/lv2/CHOWTapeModel.lv2 $out/lib/lv2/
    cp -r usr/lib/vst3/CHOWTapeModel.vst3 $out/lib/vst3/
    cp -r usr/lib/clap/CHOWTapeModel.clap $out/lib/clap/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Physical modelling tape emulation plugin (LV2/VST3/CLAP)";
    homepage = "https://chowdsp.com/products.html#tape";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "CHOWTapeModel";
  };
}
