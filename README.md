## ¿Cómo instalarlo?

### Paso 1: Copiar init.lua
mkdir -p ~/.config/nvim
curl -o ~/.config/nvim/init.lua https://raw.githubusercontent.com/augustolue-sh/nvim-zen/main/init.lua

### Paso 2: Instalar mini.nvim (único plugin, ~50KB)
git clone https://github.com/echasnovski/mini.nvim \
  ~/.config/nvim/pack/plugins/start/mini.nvim
