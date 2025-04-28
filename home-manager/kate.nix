# ~/nixos-config/home-manager/kate.nix
{ config, pkgs, lib, ... }: # Argumentos estándar de un módulo HM

{ # El módulo retorna un conjunto de atributos

  # --- PEGA AQUÍ EL BLOQUE programs.kate ---
  programs.kate = {
    enable = true;
    settings = {
      "KWrite Settings" = {
        Font = "JetBrains Mono,10,-1,5,50,0,0,0,0,0";
        "Session Restoration" = true;
        ColorScheme = "BreezeDark";
      };
      "KatePart__View" = {
        "Show Line Numbers" = true;
        "Highlight Current Line" = true;
        "Show Modification Lines" = true;
      };
      "KatePart__Document" = {
        "Word Wrap" = true;
        "Remove Trailing Spaces" = "Modified Lines";
        "Ensure Line End" = true;
      };
      "KatePart__Indentation" = {
        "Use Spaces" = true;
        "Indent Width" = 2;
        "Tab Width" = 2;
        "Auto Indent" = true;
      };
      "KatePart__Highlighting" = {
         "Default Editor Theme" = "Breeze Dark";
      };
      "Project Plugin" = {
         RestoreProject = true;
      };
      # ... más opciones ...
    };
    # extraPlugins = with pkgs; [ ... ];
  };
  # --- FIN DEL BLOQUE programs.kate PEGADO ---

  # Puedes añadir otras configuraciones relacionadas con Kate aquí si quieres

} # Fin del conjunto de atributos del módulo
