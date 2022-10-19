{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.git;

in {
    options.modules.git = { enable = mkEnableOption "git"; };
    config = mkIf cfg.enable {
        programs.git = {
            enable = true;
            userName = "fwar34";
            userEmail = "fwar34@126.com";
            aliases = {
                st = "status";
                co = "checkout";
                ci = "commit";
                br = "branch";
                last = "log -1";
                lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";

            };
            extraConfig = {
                init = { defaultBranch = "master"; };
                core = {
                    quotepath = false;
                    autocrlf = "input";
                };
                credential = {
                    helper = "store";
                };
            };
        };
    };
}
