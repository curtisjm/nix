{ ... }:
{
    programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
    };

    home.sessionVariables._ZO_DOCTOR = "0";
}
