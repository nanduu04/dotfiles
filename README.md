# Dotfiles

My personal dotfiles for macOS. These configurations help me maintain a consistent development environment across machines.

## Features

- 🐚 Zsh configuration with useful aliases and functions
- 🛠 Git configuration with extensive aliases for common operations
- 🚀 Flutter development setup
- ☁️ Google Cloud SDK integration
- 🎨 Colorful terminal experience
- 🍺 Homebrew package management
- 📦 Node.js and Ruby development tools

## Installation

```bash
# Clone the repository
git clone https://github.com/nandupokhrel/dotfiles.git ~/.dotfiles

# Run the installation script
cd ~/.dotfiles
make all
```

## Transferring to a New PC

### Prerequisites
1. Ensure you have Git installed on your new machine
2. Make sure you have access to your GitHub account
3. Have your SSH keys ready (if using SSH for Git)

### Steps to Transfer

1. **Clone the Repository**
   ```bash
   git clone https://github.com/nandupokhrel/dotfiles.git ~/.dotfiles
   ```

2. **Install Dependencies**
   ```bash
   cd ~/.dotfiles
   make all
   ```

3. **Verify Installation**
   ```bash
   # Check if all configurations are properly linked
   ls -la ~ | grep "^\." | grep -v "\.$"
   
   # Test git configuration
   git config --list
   
   # Test zsh configuration
   zsh -l
   ```

### Backup Before Transfer

Before setting up on a new machine, you might want to backup your current configurations:

```bash
# Create a backup directory
mkdir -p ~/dotfiles_backup

# Backup existing dotfiles
cp ~/.zshrc ~/dotfiles_backup/
cp ~/.gitconfig ~/dotfiles_backup/
cp ~/.gitignore ~/dotfiles_backup/

# Backup any other custom configurations
cp -r ~/.config ~/dotfiles_backup/
```

### Troubleshooting

If you encounter any issues during transfer:

1. **Check Permissions**
   ```bash
   # Ensure proper permissions
   chmod -R u+rw ~/.dotfiles
   ```

2. **Reset Links**
   ```bash
   # Unlink existing configurations
   make unlink
   
   # Relink configurations
   make link
   ```

3. **Verify Homebrew**
   ```bash
   # Check Homebrew installation
   which brew
   
   # Update Homebrew
   brew update
   ```

4. **Check Shell Configuration**
   ```bash
   # Verify zsh is your default shell
   echo $SHELL
   
   # If not, change it
   chsh -s $(which zsh)
   ```

## Structure

```
.
├── bin/              # Executable scripts
├── config/           # Configuration files for various tools
├── install/          # Installation files for packages
│   ├── Brewfile     # Homebrew packages
│   ├── Caskfile     # macOS applications
│   ├── Codefile     # VS Code extensions
│   └── npmfile      # Global npm packages
├── runcom/          # Shell configuration files
│   ├── .gitconfig   # Git configuration and aliases
│   ├── .gitignore   # Git ignore rules
│   └── .zshrc       # Zsh shell configuration
├── Makefile         # Installation and setup automation
└── README.md        # This file
```

## Git Aliases

The configuration includes numerous git aliases for common operations:

- `git a` - Stage all changes
- `git co` - Checkout with fetch
- `git cob` - Create and checkout new branch
- `git p` - Push changes
- `git r` - Rebase
- And many more...

## Available Commands

- `make all` - Install everything for your OS
- `make macos` - Install everything for macOS
- `make linux` - Install everything for Linux
- `make link` - Link dotfiles to home directory
- `make unlink` - Unlink dotfiles from home directory
- `make packages` - Install all packages
- `make brew` - Install Homebrew
- `make git` - Install Git and Git extras
- `make npm` - Install NVM and latest LTS Node.js
- `make ruby` - Install Ruby
- `make test` - Run tests

## Customization

1. Fork this repository
2. Modify the configurations to suit your needs
3. Run `make link` to apply changes

## License

MIT License - feel free to use and modify for your own needs.
