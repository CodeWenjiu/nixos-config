- pull and generate
```zsh
git pull git@github.com:CodeWenjiu/nixos-config.git
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
