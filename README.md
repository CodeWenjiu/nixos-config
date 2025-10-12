- pull and generate
```nushell
git pull git@github.com:CodeWenjiu/nixos-config.git
mkdir hosts/<your_host>
sudo nixos-generate-config --show-hardware-config | hosts/<your_host>/hardware-configuration.nix
```

- add your own host in flake.nix like `wenjiu`
    - better mount your data `/mnt/data`

- match
```nushell
sudo nixos-rebuild switch --flake .#<your_host>
```

- boot loader
nixos can not modify boot order
if you want to use grub which is configuated by this repository
try
```nushell
nix-shell -p efibootmgr --run "efibootmgr -v" # get the NixOS-boot num which direct to grub
nix-shell -p efibootmgr --run "sudo efibootmgr -o <NixOS-boot num>,<other_boot_sequence>"
```

- vscode server
```nushell
systemctl --user enable auto-fix-vscode-server.service
systemctl --user start auto-fix-vscode-server.service
```
