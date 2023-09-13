# ubuntu-config-scripts

Development environment configuration scripts for Ubuntu Desktop (22.04).

**Not intended for production. Use at your own risk!**

**Goal:** Reduce the time it takes to configure a new Ubuntu Desktop development environment.

![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

### Convenience Scripts

#### `bin/utils/add_keyring.sh`

Add a keyring to the system by providing a URL to the keyring and the complete desired path to the keyring file:

```bash
cd ./bin/utils
sudo bash ./add_keyring.sh https://example.com/apt/keys.asc \
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

> See [Ubuntu Manpage: `sources.list`](https://manpages.ubuntu.com/manpages/xenial/man5/sources.list.5.html) for more information on the format of the list file.
