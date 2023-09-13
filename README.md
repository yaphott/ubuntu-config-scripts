# ubuntu-config-scripts

Development environment configuration scripts for Ubuntu Desktop (22.04).

**Not intended for production. Use at your own risk!**

**Goal:** Reduce the time it takes to configure a new Ubuntu Desktop development environment.

![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

## Usage

```bash
git clone https://github.com/yaphott/ubuntu-config-scripts.git
cd ubuntu-config-scripts
sudo bash run.sh
```

### Convenience Scripts

#### `bin/utils/add_keyring.sh`

Add a keyring to the system by providing a URL to the keyring and the complete desired path to the keyring file:

```bash
cd ./bin/utils
sudo bash add_keyring.sh https://example.com/apt/keys.asc \
    /etc/apt/keyrings/example-keyring.gpg
```

#### `bin/utils/add_repository.sh`

Add a repository to the system by providing a keyring, URL to the public key, distribution, components, and the complete destination path for the list file:

```bash
cd ./bin/utils
sudo add_repository.sh "arch=amd64 signed-by=/etc/apt/keyrings/example-keyring.gpg" \
    https://example.com/example-pub.gpg \
    stable \
    main \
    /etc/apt/sources.list.d/example.list
```

Or if there are multiple components:

```bash
cd ./bin/utils
sudo add_repository.sh "arch=amd64 signed-by=/etc/apt/keyrings/example-keyring.gpg" \
    https://example.com/example-pub.gpg \
    stable \
    "main contrib non-free" \
    /etc/apt/sources.list.d/example.list
```

Or if there are no components:

```bash
cd ./bin/utils
sudo add_repository.sh "arch=amd64 signed-by=/etc/apt/keyrings/example-keyring.gpg" \
    https://example.com/example-pub.gpg \
    stable \
    none \
    /etc/apt/sources.list.d/example.list
```

> See [Ubuntu Manpage: `sources.list`](https://manpages.ubuntu.com/manpages/xenial/man5/sources.list.5.html) for more information on the format of the list file.

## Installation Components

Easily install and configure the following:

- | Dependencies  |                 |                     |     |      |      |          |                 |       |
  | :------------ | :-------------- | :------------------ | :-- | :--- | :--- | :------- | :-------------- | :---- |
  | linux-generic | build-essential | apt-transport-https | gpg | wget | curl | lsb-core | ca-certificates | gnupg |
- | Packages  |            |                 |                   |             |
  | :-------- | :--------- | :-------------- | :---------------- | :---------- |
  | git       | synaptic   | htop            | tmux              | awscli      |
  | net-tools | nmap       | whois           | ssh-askpass       | filezilla   |
  | nomacs    | gimp       | imagemagick     | vlc               | handbrake   |
  | bzip2     | unzip      | zstd            | file-roller       | jq          |
  | gparted   | exfatprogs | usb-creator-gtk | protobuf-compiler | libreoffice |
  | evince    | wireshark  | linssid         | sqlitebrowser     | ffmpeg      |
  | ruby-full | php        | qgis            | qgis-plugin-grass |             |
- [x] Configure DNS
- [x] Configure Firewall (UFW)
- [x] Configure Canonical Livepatch
- [x] Configure Bluetooth
- [-] Install NVIDIA CUDA
- [x] Configure SSH
- [ ] Install HTop
- [x] Install Python 3
- [x] Configure Python 3
- [ ] Install CmdStan
- [ ] Install MuJoCo
- [ ] Configure Streamlit
- [x] Install Node.js
- [x] Install Yarn
- [-] Install Scala
- [-] Install Rust
- [x] Install FiraCode Font
- [x] Install Sublime Text
- [x] Install Visual Studio Code
- [x] Install Google Cloud CLI
- [x] Install Google Firebase CLI
- [x] Install Signal Desktop
- [x] Install Bitwarden
- [x] Install Telegram Desktop
- [x] Install Spotify
- [x] Install Oracle VirtualBox
- [x] Configure Oracle VirtualBox
- [x] Install Docker
- [x] Install Vagrant
- [x] Configure Vagrant
- [ ] Configure Mozilla Firefox
- [x] Install Google Chrome
- [ ] Configure Google Chrome
- [ ] Install Geckodriver
- [ ] Install Chromedriver
- [ ] Install Anaconda
- [x] Configure dconf
- [x] Configure Swapfile
- [x] Configure Power Mode
