- pull and generate
```zsh
git pull git@github.com:CodeWenjiu/nixos-config.git
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

- match
```zsh
sudo nixos-rebuild switch --flake .#wenjiu
```

- vscode server
```bash
systemctl --user enable auto-fix-vscode-server.service 
systemctl --user start auto-fix-vscode-server.service 
```
