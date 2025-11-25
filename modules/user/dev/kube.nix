{pkgs, ...}: {
  imports = [];

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
          ''            tempfile=$(mktemp);
                        secret=$(kubectl get secrets --context $CONTEXT --namespace $NAMESPACE $NAME -o json);
                        printf '%s\n' $secret | jq '.data | map_values(@base64d)' > $tempfile;
                        vim $tempfile;
                        secret_data=$(cat $tempfile | jq -c '. | map_values(@base64)');
                        rm $tempfile;
                        printf '%s\n' $secret | jq -r --argjson secret_data "$secret_data" '.data = $secret_data' | kubectl apply  --context $CONTEXT --namespace $NAMESPACE -f -;
          ''
        ];
      };
      # refresh-apps:
      #   shortCut: Shift-R
      #   confirm: false
      #   scopes:
      #     - apps
      #   description: Refresh a argocd app hard
      #   command: bash
      #   background: false
      #   args:
      #     - -c
      #     - "kubectl annotate applications -n argocd $NAME argocd.argoproj.io/refresh=hard"
      #
      # disable-auto-sync:
      #   shortCut: Ctrl-P
      #   confirm: false
      #   scopes:
      #     - apps
      #   description: Disable argocd sync
      #   command: kubectl
      #   background: false
      #   args:
      #     - patch
      #     - applications
      #     - -n
      #     - argocd
      #     - $NAME
      #     - "--type=json"
      #     - '-p=[{"op":"replace", "path": "/spec/syncPolicy", "value": {}}]'
      #
      # enable-auto-sync:
      #   shortCut: Shift-B
      #   confirm: false
      #   scopes:
      #     - apps
      #   description: Enable argocd sync
      #   command: kubectl
      #   background: false
      #   args:
      #     - patch
      #     - applications
      #     - -n
      #     - argocd
      #     - $NAME
      #     - --type=merge
      #     - '-p={"spec":{"syncPolicy":{"automated":{"prune":true,"selfHeal":true},"syncOptions":["ApplyOutOfSyncOnly=true","CreateNamespace=true","PruneLast=true","PrunePropagationPolicy=foreground"]}}}'
      #
    };
  };
}
