{...}: {
  imports = [
    ./common.nix
    ./direnv.nix
    ./docker.nix
    ./git.nix
    ./kube.nix
    ./llm.nix
    ./sqlite.nix
    ./vscode.nix
    ./websocat.nix
  ];
}
