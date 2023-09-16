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
make test-hot
```

> **Note**: Password for the user is `vagrant`.

### Convenience Scripts

#### `bin/utils/add_keyring.sh`

Add a keyring to the system by providing a URL to the keyring and the complete desired path to the keyring file.

```bash
sudo add_keyring.sh <key URL> <keyring path>
```

For example:

```bash
cd ./bin/utils
sudo bash add_keyring.sh https://example.com/apt/keys.asc \
    /etc/apt/keyrings/example-keyring.gpg
```

#### `bin/utils/add_repository.sh`

Add a repository to the system by providing the **key URL**, **distribution**, **components**, and the **destination path for the list file**.

```bash
sudo add_repository.sh <key options> <key URL> <distribution> <components> <list file path>
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
