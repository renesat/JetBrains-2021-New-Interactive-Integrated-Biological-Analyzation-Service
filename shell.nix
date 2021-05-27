{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "PaperSuccessPredictor";

  venvDir = "./.venv";

  buildInputs = with pkgs; [
    # A Python interpreter including the 'venv' module is required to bootstrap
    # the environment.
    python38Packages.python

    # This execute some shell code to initialize a venv in $venvDir before
    # dropping into the shell
    python38Packages.venvShellHook

    # Those are dependencies that we would like to use from nixpkgs, which will
    # add them to PYTHONPATH and thus make them accessible from within the venv.
    python38Packages.numpy
    python38Packages.requests

    # In this particular example, in order to compile any binary extensions they may
    # require, the Python modules listed in the hypothetical requirements.txt need
    # the following packages to be installed locally:
    taglib
    openssl
    git
    libxml2
    libxslt
    libzip
    zlib
    nodejs

    tmux
  ];

  postVenvCreation = ''
    unset SOURCE_DATE_EPOCH
    export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/:$LD_LIBRARY_PATH
    pip install -r requirements.txt
  '';

  postShellHook = ''
    # allow pip to install wheels
    export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/:$LD_LIBRARY_PATH
    unset SOURCE_DATE_EPOCH
  '';
}
