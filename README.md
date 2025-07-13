# ubuntu-config-scripts

Development environment configuration scripts for Ubuntu Desktop.

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

Testing occurs in 2 stages:

1. Provision a base box and create a snapshot.
2. Restore the snapshot and run the configuration scripts.

> Creating the snapshot reduces the overall time needed to test the configuration scripts in a clean environment.

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
add_keyring.sh <key_url> <key_file_path>
```

For example using a **binary** GPG keyring URL:

```bash
key_url="https://example.com/apt/keys.gpg"
key_file_path="/etc/apt/keyrings/example-keyring.gpg"
sudo bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}"
```

Or using an **ASCII-armored** GPG keyring URL:

```bash
key_url="https://example.com/apt/keys.asc"
key_file_path="/etc/apt/keyrings/example-keyring.gpg"
sudo bash ./bin/utils/add_keyring.sh "${key_url}" "${key_file_path}"
```

#### `bin/utils/add_repository.sh`

Add a repository to the system by providing the **repository options**, **repository URI**, **repository suite**, **repository components**, and the **desired path for the repository list file**.

```bash
add_repository.sh <repo_options> <repo_uri> <repo_suite> <repo_components> <repo_file_path>
```

For example, if there is **one component**:

```bash
key_file_path="/etc/apt/keyrings/example-keyring.gpg"
repo_options="arch=$(dpkg --print-architecture) signed-by=${key_file_path}"
repo_uri="https://apt.releases.example.com"
repo_suite="$(lsb_release -cs)"
repo_components="main"
repo_file_path="/etc/apt/sources.list.d/example.list"
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}"
```

Or if there are **multiple components**:

```bash
key_file_path="/etc/apt/keyrings/example-keyring.gpg"
repo_options="arch=$(dpkg --print-architecture) signed-by=${key_file_path}"
repo_uri="https://apt.releases.example.com"
repo_suite="$(lsb_release -cs)"
repo_components="main contrib non-free"
repo_file_path="/etc/apt/sources.list.d/example.list"
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}"
```

Or if there are **no components**:

```bash
key_file_path="/etc/apt/keyrings/example-keyring.gpg"
repo_options="arch=$(dpkg --print-architecture) signed-by=${key_file_path}"
repo_uri="https://apt.releases.example.com"
repo_suite="$(lsb_release -cs)"
repo_components=""
repo_file_path="/etc/apt/sources.list.d/example.list"
bash ./bin/utils/add_repository.sh "${repo_options}" "${repo_uri}" "${repo_suite}" "${repo_components}" "${repo_file_path}"
```

> See [Ubuntu Manpage: `sources.list`](https://manpages.ubuntu.com/manpages/xenial/man5/sources.list.5.html) for more information on the format of the list file.

## Developer Notes

All install and configuration scripts should attempt to verify the necessary setup and/or configuration has completed successfully.

### Installing Vagrant Plugins

Install the required Vagrant plugins by running the following command:

```bash
vagrant plugin install vagrant-disksize
```

### Updating Vagrant Plugins

Update installed Vagrant plugins by running the following command:

```bash
vagrant plugin update
```

### Watching Dconf Changes

```bash
dconf watch /
```

### Watching for File/Config Changes

To monitor changes to specific directories or files, you can use the `inotifywatch` command:

```bash
inotifywatch -e modify,create,delete -r ~/.config
inotifywatch -e modify,create,delete -r ~/snap/firefox/common/.mozilla
inotifywatch -e modify,create,delete -r ~/.local
inotifywatch -e modify,create,delete -r /etc/default
```

> **Note**: The above commands require `inotify-tools` to be installed. You can install it using the following command:

```bash
sudo apt-get update
sudo apt-get install inotify-tools
```
