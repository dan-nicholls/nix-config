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
- [x] tmux configuration
- [x] shell (zsh)
- [x] terminal
- [ ] tmuxinator
- [ ] aliases
- [x] add power usage (W)
- [x] Update dock pinned apps
- [x] Guide for adding GNOME extensions

## 🧩 Adding GNOME Extensions

To install and enable GNOME Shell extensions declaratively with Home Manager:

### 1. Add the extension package

Find the extension in [nixpkgs gnomeExtensions](https://search.nixos.org/packages?channel=unstable&query=gnomeExtensions) and add it to `home.packages`:

```nix
home.packages = with pkgs; [
  gnomeExtensions.system-monitor
];
```

---

### 2. Find the extension’s UUID

Use `gnome-extensions` to list installed extensions and find the **UUID**:

```bash
gnome-extensions list
```

Alternatively use the extension-manager tool.

---

### 3. Enable the extension in `dconf.settings`

Add the extension's UUID to the list of enabled extensions:

```nix
dconf.settings = {
  "org/gnome/shell" = {
    disable-user-extensions = false; # Ensure this is enabled
    enabled-extensions = [
      "system-monitor@gnome-shell-extensions.gcampax.github.com"
    ];
  };
};
```

If the extension requires configuration, you can add it like:

~~~nix
"org/gnome/shell/extensions/system-monitor" = {
  show-indicator = true;
};
~~~

---

After saving changes, apply with:

```bash
home-manager switch
```
