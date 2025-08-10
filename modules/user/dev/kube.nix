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
          k9s
          kubectl
          kubernetes-helm
          ;
      };
    };

    programs.k9s = {
      enable = true;
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
              tempfile=$(mktemp);
              secret=$(kubectl get secrets --context $CONTEXT --namespace $NAMESPACE $NAME -o json);
              printf '%s\n' $secret | jq '.data | map_values(@base64d)' > $tempfile;
              vim $tempfile;
              secret_data=$(cat $tempfile | jq -c '. | map_values(@base64)');
              rm $tempfile;
              printf '%s\n' $secret | jq -r --argjson secret_data "$secret_data" '.data = $secret_data' | kubectl apply  --context $CONTEXT --namespace $NAMESPACE -f -;
            ''
          ];
        };
      };
    };
  };
}
