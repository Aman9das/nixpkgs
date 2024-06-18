{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, writeText
, shellspec
  # usage:
  # pkgs.mommy.override {
  #  mommySettings.sweetie = "catgirl";
  # }
  #
  # $ mommy
  # who's my good catgirl~
, mommySettings ? null
}:

let
  variables = lib.mapAttrs'
    (name: value: lib.nameValuePair "MOMMY_${lib.toUpper name}" value)
    mommySettings;
  configFile = writeText "mommy-config" (lib.toShellVars variables);
in
stdenv.mkDerivation rec {
  pname = "mommy";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "FWDekker";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kNhoEIzrPjCe6RA/GHFB/NtKjYFByM5TpxAwCLo5TDo=";
  };

  nativeBuildInputs = [ makeWrapper ];
  nativeCheckInputs = [ shellspec ];
  installFlags = [ "prefix=$(out)" ];

  doCheck = true;
  checkTarget = "test/unit";

  postInstall = ''
    ${lib.optionalString (mommySettings != null) ''
      wrapProgram $out/bin/mommy \
        --set-default MOMMY_OPT_CONFIG_FILE "${configFile}"
    ''}
  '';

  meta = with lib; {
    description = "mommy's here to support you, in any shell, on any system~ ❤️";
    homepage = "https://github.com/FWDekker/mommy";
    changelog = "https://github.com/FWDekker/mommy/blob/v${version}/CHANGELOG.md";
    license = licenses.unlicense;
    platforms = platforms.all;
    maintainers = with maintainers; [ ckie ];
    mainProgram = "mommy";
  };
}
