#!/bin/bash
set -e

echo "Setting up development environment..."

# Copy dotfiles to home directory
cp -r /usr/local/share/dotfiles/.zshrc /home/jsnchn/
cp -r /usr/local/share/dotfiles/.tmux.conf /home/jsnchn/
cp -r /usr/local/share/dotfiles/.config /home/jsnchn/
cp -r /usr/local/share/dotfiles/.default-npm-packages /home/jsnchn/

# Handle opencode config with token substitution
if [ -f "/usr/local/share/dotfiles/.config/opencode/config.json.template" ]; then
    if [ -n "$GITHUB_COPILOT_TOKEN" ]; then
        # Substitute the token if environment variable is set
        sed "s/\${GITHUB_COPILOT_TOKEN}/$GITHUB_COPILOT_TOKEN/g" \
            /usr/local/share/dotfiles/.config/opencode/config.json.template \
            > /home/jsnchn/.config/opencode/config.json
    else
        # Copy template as-is if no token provided
        cp /usr/local/share/dotfiles/.config/opencode/config.json.template \
           /home/jsnchn/.config/opencode/config.json
        echo "Warning: GITHUB_COPILOT_TOKEN not set. OpenCode GitHub integration will not work."
    fi
fi

# Install mise
curl https://mise.run | sh
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
tar xzf nvim-linux64.tar.gz
mv nvim-linux64 /opt/nvim
ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim
rm nvim-linux64.tar.gz

# Install LazyVim dependencies
apt-get update && apt-get install -y \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    golang \
    rustc \
    cargo

# Install language servers and tools for Neovim
npm install -g neovim
pip3 install pynvim

# Install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit /usr/local/bin
rm lazygit.tar.gz lazygit

# Install slumber HTTP client
curl -LO https://github.com/LucasPickering/slumber/releases/latest/download/slumber-x86_64-unknown-linux-gnu
chmod +x slumber-x86_64-unknown-linux-gnu
mv slumber-x86_64-unknown-linux-gnu /usr/local/bin/slumber

# Install harlequin SQL client
pip3 install harlequin

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all --no-bash --no-fish

# Install lazydocker
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
mv lazydocker /usr/local/bin/

# Set up mise tools
export PATH="$HOME/.local/bin:$PATH"
~/.local/bin/mise install

# Initialize tmux plugins
tmux start-server
tmux new-session -d
~/.tmux/plugins/tpm/scripts/install_plugins.sh
tmux kill-server

# Fix ownership
chown -R jsnchn:jsnchn /home/jsnchn

echo "Development environment setup complete!"