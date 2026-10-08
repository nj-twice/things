mkdir -p $out/bin

for name in backup masspush
    set original $src/src/$name/main.fish
    set exe $out/bin/$name

    printf %s\n $shebang $newPathLine "source $original" >$exe
    chmod +x $exe
end
