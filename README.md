# setup

Run the setup script directly without cloning the repo:

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/aashishamrute/setup/main/setup.sh)
```

## Config-only mode

Once the repo is cloned at `~/personal/gitws/setup`, re-link just the dotfiles
(no Homebrew / SDKMAN / nvm / TPM installs, no sudo) with:

```sh
~/personal/gitws/setup/macos/setup.sh configs
```
