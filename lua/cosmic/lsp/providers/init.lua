local u = require('cosmic.utils')
local default_config = require('cosmic.lsp.providers.defaults')
local user_config = require('cosmic.core.user')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')

-- initial default servers
-- by default tsserver/ts_utils and null_ls are enabled
local requested_servers = {}

-- get disabled servers from config
local disabled_servers = {}
for config_server, config_opt in pairs(user_config.lsp.servers) do
  if config_opt == false then
    table.insert(disabled_servers, config_server)
  elseif not vim.tbl_contains(requested_servers, config_server) then
    -- add additonally defined servers to be installed
    table.insert(requested_servers, config_server)
  end
end

mason_lspconfig.setup_handlers({
  function(server_name)
    local opts = default_config

    -- disable server if config disabled server list says so
    opts.autostart = true
    if vim.tbl_contains(disabled_servers, server_name) then
      opts.autostart = false
    end

    -- set up default cosmic options
    if server_name == 'tsserver' then
      opts = u.merge(opts, require('cosmic.lsp.providers.tsserver'))
    elseif server_name == 'jsonls' then
      opts = u.merge(opts, require('cosmic.lsp.providers.jsonls'))
    elseif server_name == 'pyright' then
      opts = u.merge(opts, require('cosmic.lsp.providers.pyright'))
    elseif server_name == 'sumneko_lua' then
      opts = u.merge(opts, require('cosmic.lsp.providers.sumneko_lua'))
    end

    -- override options if user definds them
    if type(user_config.lsp.servers[server_name]) == 'table' then
      if user_config.lsp.servers[server_name].opts ~= nil then
        opts = u.merge(opts, user_config.lsp.servers[server_name].opts)
      end
    end

    require('lspconfig')[server_name].setup(opts)
  end,
})

mason.setup({
  ui = {
    border = user_config.border,
    keymaps = {
      -- Keymap to expand a server in the UI
      toggle_server_expand = 'i',
      -- Keymap to install a server
      install_server = '<CR>',
      -- Keymap to reinstall/update a server
      update_server = 'u',
      -- Keymap to uninstall a server
      uninstall_server = 'x',
    },
  },
})
mason_lspconfig.setup({
  ensure_installed = requested_servers,
  automatic_installation = true,
})
