{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.user.dev.kube.enable = lib.mkEnableOption "kubernetes tools and k9s" // {default = true;};
  };

  config = lib.mkIf (config.custom.user.dev.enable && config.custom.user.dev.kube.enable) {
    home = {
      packages = builtins.attrValues {
        inherit
          (pkgs)
          argocd
          jq
          k9s
          kubectl
          kubernetes-helm
          vim
          ;
      };
    };

    programs.k9s = {
      enable = true;
      settings = {
        k9s = {
          refreshRate = 2;
          thresholds = {
            memory = {
              warn = 80;
              error = 90;
            };
          };
          # ui = {
          #   skin = "nord";
          #   enableMouse = false;
          #   headless = false;
          #   logoless = false;
          #   crumbsless = false;
          #   noIcons = false;
          #   # Toggles reactive UI. This option provide for watching on disk artifacts changes and update the UI live  Defaults to false.;
          #   reactive = false;
          # };
        };
      };
      plugins = {
        argocd = {
          shortCut = "s";
          description = "Sync ArgoCD Application";
          scopes = ["application"];
          command = "${pkgs.argocd}/bin/argocd";
          args = [
            "app"
            "sync"
            "$NAME"
            "--app-namespace"
            "$NAMESPACE"
          ];
          background = true;
          confirm = true;
        };
        edit-secret = {
          shortCut = "Ctrl-X";
          confirm = false;
          description = "Edit Decoded Secret";
          scopes = ["secrets"];
          command = "sh";
          background = false;
          args = [
            "-c"
            ''
              tempfile=$(${pkgs.coreutils}/bin/mktemp);
              secret=$(${pkgs.kubectl}/bin/kubectl get secrets --context $CONTEXT --namespace $NAMESPACE $NAME -o json);
              # Handle null/empty secret data gracefully
              if [ "$(${pkgs.coreutils}/bin/printf '%s\n' "$secret" | ${pkgs.jq}/bin/jq -r '.data // empty')" = "null" ] || [ "$(${pkgs.coreutils}/bin/printf '%s\n' "$secret" | ${pkgs.jq}/bin/jq -r '.data // {}')" = "{}" ]; then
                ${pkgs.coreutils}/bin/printf '{}' > $tempfile;
              else
                ${pkgs.coreutils}/bin/printf '%s\n' $secret | ${pkgs.jq}/bin/jq '.data | map_values(@base64d)' > $tempfile;
              fi
              ${pkgs.vim}/bin/vim $tempfile;
              secret_data=$(${pkgs.coreutils}/bin/cat $tempfile | ${pkgs.jq}/bin/jq -c '. | map_values(@base64)');
              ${pkgs.coreutils}/bin/rm $tempfile;
              ${pkgs.coreutils}/bin/printf '%s\n' $secret | ${pkgs.jq}/bin/jq -r --argjson secret_data "$secret_data" '.data = $secret_data' | ${pkgs.kubectl}/bin/kubectl apply  --context $CONTEXT --namespace $NAMESPACE -f -;
            ''
          ];
        };
      };
    };
  };
}
