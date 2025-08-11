- pull and generate
```zsh
git pull git@github.com:CodeWenjiu/nixos-config.git
mkdir hosts/<your_host>
sudo nixos-generate-config --show-hardware-config | hosts/<your_host>/hardware-configuration.nix
```

- add your own host in flake.nix like `wenjiu`

- match
```zsh
sudo nixos-rebuild switch --flake .#wenjiu
```

- vscode server
```bash
systemctl --user enable auto-fix-vscode-server.service 
systemctl --user start auto-fix-vscode-server.service 
```
