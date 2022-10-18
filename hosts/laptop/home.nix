{ config, lib, inputs, ...}:

{
    #imports = [ ../../modules/default.nix ];
    config.modules = {
        # gui
        firefox.enable = false;
        foot.enable = true;
        eww.enable = true;
        dunst.enable = true;
        hyprland.enable = true;
        wofi.enable = true;

        # cli
        nvim.enable = true;
        zsh.enable = true;
        git.enable = true;
        gpg.enable = true;
        direnv.enablefalse = false;

        # system
        xdg.enable = true;
        packages.enable = true;
    };
}
