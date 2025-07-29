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
