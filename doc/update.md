# Updating NixOS

1. create a new set of flake inputs with newest NixOS version,
   and all needed dependencies
1. migrate hosts one by one
1. keep up to date list of which host is on which version
   in comment in flake inputs, so that old ones can be deleted

## Services that need migration

### Mailserver

It will fail an assertion if a migration is needed based on `mailserver.stateVersion`,
so just follow the docs in that case.

### Mongo

Probably mongo, but I pin some exact nixpkgs for it, and I'll
not keep it around for long probably, so no need for migrations.

### Postgres

1. Install new NixOS but pin old version of postgres
1. Disable postgres systemd service
1. Install new postgres cli in nix-shell
1. Run `upgrade`
1. Upgrade postgres version in NixOS config and rebuild


## Deprecation notes (TODO)

evaluation warning: vladidobro profile: The option `programs.git.aliases' defined in `/nix/store/flnpikzqmn2dlnp4scddh7kz6k0lm8b8-source/nixos/common.nix' has been renamed to `programs.git.settings.alias'.
evaluation warning: vladidobro profile: The option `programs.git.userName' defined in `/nix/store/flnpikzqmn2dlnp4scddh7kz6k0lm8b8-source/nixos/common.nix' has been renamed to `programs.git.settings.user.name'.
evaluation warning: vladidobro profile: The option `programs.git.extraConfig' defined in `/nix/store/flnpikzqmn2dlnp4scddh7kz6k0lm8b8-source/nixos/common.nix' has been renamed to `programs.git.settings'.
evaluation warning: vladidobro profile: `programs.ssh` default values will be removed in the future.
                    Consider setting `programs.ssh.enableDefaultConfig` to false,
                    and manually set the default values you want to keep at
                    `programs.ssh.matchBlocks."*"`.

