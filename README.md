# OP AWS Vault
Overpowered AWS Vault (with 1Password)!

Do you use AWS?
Do you use `aws-vault` to run commands?
Do you use 1Password?

Are you tired of having to leave your terminal, open 1Password, find your AWS account, copy the MFA, and then go back to your terminal and enter your token before it resets, LIKE A PLEB?  Then this is the plugin for you!  With OPAV, you can generate MFA tokens to be auto-magically inserted into your `aws-vault` commands with ease!  Amaze your friends!  Terrify your enemies with your lightning-fast aws commands!  Install OPAV today!

## Requirements
The following programs should be installed to use this plugin:
* [aws-vault](https://github.com/99designs/aws-vault)
* [1password](https://1password.com/)
* [1password CLI](https://1password.com/downloads/command-line/)
* [fzf](https://github.com/junegunn/fzf)
* [jq](https://stedolan.github.io/jq/)

On OSX, all requirements can be installed via Homebrew:
``` shell
brew install fzf jq
brew cask install aws-vault 1password 1password-cli
```

## Installation
### ZSH
For ZSH, it's recommended to use your favorite plugin manager, such as Antigen.  Simply add the plugin to the set of plugins in your `.zshrc` file (or wherever your plugin manager requires):
```
antigen bundle https://gitlab.com/kevinziegler/opav.git
```
Restart your shell, and you're all set!

### Bash / ZSH without a plugin manager
If you're using Bash, you can simply clone and source the plugin in your shell's config file.  Similarly, you can source the ZSH plugin in place of using a plugin manager.
``` shellsession
git clone git@gitlab.com:kevinziegler/opav.git

# Source the plugin for bash
echo "source $PWD/opav/opav.plugin.bash" >> ~/.bashrc

# Source the standalone plugin in ZSH
echo "source $PWD/opav/opav.plugin.zsh" >> ~/.bashrc
```
Restart your shell, and you're all set!

## Usage
This plugin adds 3 aliases:
* `opav` - Use this in place of aws-vault for an over-powered experience
* `avp` - Use the power of FZF to select an aws profile!
* `opav-setup` - Configure opav

### Setup
1. Be sure you have 1Password setup on your computer with your 1Password account
2. [Configure 1Password as your AWS MFA provider](https://support.1password.com/one-time-passwords/)
3. Run `opav-setup` to select the 1Password item containing your AWS account credentials
``` shellsession
opav-setup
```

### Running aws-vault commands with opav
`opav` aims to act as a simple wrapper around the aws-vault binary.  Where you would use `aws-vault`, simply substitute `opav`:

``` shellsession
aws-vault exec <aws profile> -- aws sts get-caller-identity
opav exec <aws profile> -- aws sts get-caller-identity
```

When running a command that requires an MFA token, OPAV will launch a 1Password session in your terminal.  You'll be prompted for your 1Password master password, and then `opav` will fetch an MFA token to use for AWS authentication.  Finally, no more jumping between windows for MFA codes!

### Selecting profiles for use with aws-vault
Remembering things is hard and lame, especially when it's that random aws profile alias you almost never need and have to look up every time you use it.  Why bother memorizing things when you can use your awesome FZF powers instead?

The OPAV plugin also installs an alias (`avp`) for selecting a profile to use when running `aws-vault`/`opav` commands.  Simply run the alias as a subshell where you want to insert the profile in your command:
``` shellsession
aws-vault exec $(avp) -- <some command>
opav exec $(avp) -- <some command>
```
