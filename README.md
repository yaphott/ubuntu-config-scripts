# ubuntu-config-scripts

Development environment configuration scripts for Ubuntu Desktop (22.04).

**Not intended for production. Use at your own risk!**

**Goal:** Reduce the time it takes to configure a new Ubuntu Desktop environment for software development.

![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

## Usage

1. Clone the repo:

    ```bash
    git clone https://github.com/yaphott/ubuntu-config-scripts.git
    ```

2. Run the script:

    ```bash
    cd ubuntu-config-scripts
    bash ./run.sh
    ```

3. A system upgrade will commence and the **system will prompt to reboot**.
4. After rebooting, **run the script once more and respond to any prompts**.

## Testing with Vagrant

Testing occurs in 2 steps.

1. Provision a base box and create a snapshot.
2. Restore the snapshot and run the configuration scripts.

Creating the snapshot reduces the overall time needed to test the configuration scripts in a clean environment.

First time (base box + main box):

```bash
make test-cold
```

Subsequent times (main box):

```bash
make test-warm
```

> **Note**: Password for the user is `vagrant`.

### Convenience Scripts

#### `bin/utils/add_keyring.sh`

Add a keyring to the system by providing a **key URL** and the **desired path for the keyring file**.

```bash
sudo add_keyring.sh <key_url> <keyring_path>
```

For example:

```bash
cd ./bin/utils
sudo bash add_keyring.sh https://example.com/apt/keys.asc \
    /etc/apt/keyrings/example-keyring.gpg
```

#### `bin/utils/add_repository.sh`

Add a repository to the system by providing the **key URL**, **distribution**, **components**, and the **desired path for the list file**.

```bash
sudo add_repository.sh <repo_options> <repo_uri> <repo_suite> <repo_components> <repo_filepath>
```

For example, if there is **one component**:

```bash
cd ./bin/utils
sudo add_repository.sh "arch=amd64 signed-by=/etc/apt/keyrings/example-keyring.gpg" \
    https://example.com/example-pub.gpg \
    stable \
    main \
    /etc/apt/sources.list.d/example.list
```

Or if there are **multiple components**:

```bash
cd ./bin/utils
sudo add_repository.sh "arch=amd64 signed-by=/etc/apt/keyrings/example-keyring.gpg" \
    https://example.com/example-pub.gpg \
    stable \
    "main contrib non-free" \
    /etc/apt/sources.list.d/example.list
```

Or if there are **no components**:

```bash
cd ./bin/utils
sudo add_repository.sh "arch=amd64 signed-by=/etc/apt/keyrings/example-keyring.gpg" \
    https://example.com/example-pub.gpg \
    stable \
    none \
    /etc/apt/sources.list.d/example.list
```

> See [Ubuntu Manpage: `sources.list`](https://manpages.ubuntu.com/manpages/xenial/man5/sources.list.5.html) for more information on the format of the list file.

## Developer Notes

Each file starts with a check to ensure the necessary setup has been completed.

## Todo

- [ ] Add helpers for downloading files.
- [ ] Add check for existing keys and repositories.
- [ ] Add check for existing packages.
- [ ] Add check for existing configuration files.
- [ ] Add validation for configuration changes.

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
- [x] Install NVIDIA CUDA
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
