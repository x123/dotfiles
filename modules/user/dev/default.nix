{...}: {
  imports = [
    ./direnv.nix
    ./docker.nix
    ./git.nix
    # ./llm.nix
    ./sqlite.nix
    ./vscode.nix
  ];
}
