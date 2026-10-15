# Development shell for building Manim's docs.
# Tested with Manim v0.21.0, the latest version provided by Nixpkgs at the time.
# A smaller [TeX Scheme](https://wiki.nixos.org/wiki/TexLive) might also work, although I haven't tested it.
pkgs:
let
  pythonWithPackages = pkgs.python3.withPackages (
    pyPkgs: with pyPkgs; [
      manim
      furo
      myst-parser
      sphinx
      sphinx-copybutton
      sphinxext-opengraph
      sphinx-design
      sphinx-reredirects
      sphinxcontrib-programoutput
      jupyterlab
      pytest
      typst
    ]
  );
  texliveWithPackages = pkgs.texliveSmall.withPackages (
    texPkgs: with texPkgs; [
      amsmath
      babel-english
      cbfonts-fd
      cm-super
      count1to
      ctex
      doublestroke
      dvisvgm
      everysel
      fontspec
      frcursive
      fundus-calligra
      gnu-freefont
      jknapltx
      latex-bin
      mathastext
      microtype
      multitoc
      physics
      preview
      prelim2e
      ragged2e
      relsize
      rsfs
      setspace
      standalone
      tipa
      wasy
      wasysym
      xcolor
      xetex
      xkeyval
    ]
  );
in
pkgs.mkShell {
  packages = with pkgs; [
    typst
    gnumake
    sphinx
    manim
    pythonWithPackages
    texliveWithPackages
  ];
}
