{...}: {
  imports = [
    # ./llm.nix
    ./direnv.nix
    ./docker.nix
    ./git.nix
    ./kube.nix
    ./sqlite.nix
    ./vscode.nix
    ./websocat.nix
  ];
}
