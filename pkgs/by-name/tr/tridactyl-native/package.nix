{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage {
  pname = "tridactyl-native";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "tridactyl";
    repo = "native_messenger";
    rev = "62f19dba573b924703829847feb1bfee68885514";
    sha256 = "sha256-YGDVcfFcI9cRCCZ4BrO5xTuI9mrGq1lfbEITB7o3vQQ=";
  };

  lockFile = ./lock.json;

  installPhase = ''
    mkdir -p "$out/lib/mozilla/native-messaging-hosts"
    sed -i -e "s|REPLACE_ME_WITH_SED|$out/bin/native_main|" "tridactyl.json"
    cp tridactyl.json "$out/lib/mozilla/native-messaging-hosts/"
  '';

  meta = with lib; {
    description =
      "Native messenger for Tridactyl, a vim-like Firefox webextension";
    mainProgram = "native_main";
    homepage = "https://github.com/tridactyl/native_messenger";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ timokau dit7ya ];
  };
}
