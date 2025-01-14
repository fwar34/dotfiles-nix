{ config, lib, inputs, ...}:

{
    # imports = [ ../../modules/default.nix ];
    config.modules = {
        # gui
        firefox.enable = false;
        foot.enable = false;
        eww.enable = false;
        dunst.enable = false;
        hyprland.enable = false;
        wofi.enable = false;

        # cli
        nvim.enable = true;
        emacs.enable = true;
        zsh.enable = true;
        git.enable = true;
        gpg.enable = false;
        direnv.enable = false;

        # system
        xdg.enable = false;
        packages.enable = false;
    };
}
