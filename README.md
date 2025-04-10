# nix-config

a nix-flakes port for managing my dotfile configurations. This is currently tailored for a system running `nix` and `home-manager` on **Ubuntu 24.04** (not NixOS).

## ⚙️ Prerequisites

Before using this configuration, make sure you have the following installed:

- [Nix](https://nixos.org/download/) with Flakes enabled
- [Home Manager](https://github.com/nix-community/home-manager)

## 🚀 Getting Started

1. Clone the repository

```
git clone git@github.com:dan-nicholls/nix-config.git
```

2. Apply the configuration with Home Manager:

```
home-manager switch --flake <path-to-repo>#laptop
```
Replace `<path-to-repo>` with the path where you cloned the repo.

## 🛠️ TODO

- [ ] NVIM configuration
- [ ] tmux configuration
- [ ] shell (zsh)
- [ ] terminal
- [ ] tmuxinator
- [ ] aliases
- [ ] add power usage (W)

