-- ref: https://gitlab.com/domsch1988/mvim/-/blob/main/init.lua?ref_type=heads

local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

local MiniDeps = require("mini.deps")
MiniDeps.setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
	add("folke/tokyonight.nvim")
	vim.cmd('colorscheme tokyonight-storm')
end)

-- [[ Settings ]]
now(function()
	vim.g.mapleader = ","
	vim.g.maplocalleader = ","
	vim.g.have_nerd_font = false

	vim.opt.number = true
	vim.opt.mouse = "a"
	vim.opt.showmode = false
	vim.opt.breakindent = true
	vim.opt.undofile = true
	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.signcolumn = "yes"
	vim.opt.updatetime = 800
	vim.opt.timeoutlen = 500
	vim.opt.splitright = true
	vim.opt.splitbelow = true
	vim.opt.list = true
	vim.opt.listchars = { eol = "¬", tab = "› ", trail = "·", nbsp = "␣" }
	vim.opt.inccommand = "split"
	vim.opt.cursorline = true
	vim.opt.scrolloff = 5
	vim.opt.wrap = true
	vim.opt.foldlevelstart = 99
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
	vim.opt.laststatus = 2
	vim.opt.hlsearch = true
	vim.opt.completeopt = { 'menu', 'menuone' }
end)

later(function() require("mini.ai").setup() end)
later(function() require("mini.align").setup() end)
later(function()
	require("mini.basics").setup({
		options = { extra_ui = true },
	})
end)
later(function() require("mini.bracketed").setup() end)
later(function() require("mini.comment").setup() end)
later(function() require("mini.cursorword").setup() end)
later(function() require("mini.diff").setup() end)
later(function() require("mini.doc").setup() end)
later(function() require("mini.extra").setup() end)
later(function() require("mini.files").setup() end)
later(function() require("mini.fuzzy").setup() end)
later(function() require("mini.git").setup() end)
now(function()
	local hipatterns = require("mini.hipatterns")
	hipatterns.setup({
		highlighters = {
			fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
			hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
			todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
			note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
			-- Highlight hex color strings (`#rrggbb`) using that color
			hex_color = hipatterns.gen_highlighter.hex_color(),
		},
	})
end)
later(function() require("mini.notify").setup() end)
later(function() require('mini.operators').setup() end)
later(function()
	local win_config = function()
		local height = math.floor(0.618 * vim.o.lines)
		local width = math.floor(0.618 * vim.o.columns)
		return {
			anchor = 'NW',
			height = height,
			width = width,
			row = math.floor(0.5 * (vim.o.lines - height)),
			col = math.floor(0.5 * (vim.o.columns - width)),
		}
	end
	require("mini.pick").setup({
		window = { config = win_config }
	})
	-- Make `:Pick files` accept `cwd`
	require('mini.pick').registry.files = function(local_opts)
		local opts = { source = { cwd = local_opts.cwd } }
		local_opts.cwd = nil
		return MiniPick.builtin.files(local_opts, opts)
	end
end)
later(function() require("mini.splitjoin").setup() end)
later(function() require("mini.surround").setup() end)
later(function()
	MiniStatusline = require("mini.statusline")
	MiniStatusline.setup({
		content = {
			active = function()
				local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
				local git           = MiniStatusline.section_git({ trunc_width = 40 })
				local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
				local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
				local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
				local location      = MiniStatusline.section_location({ trunc_width = 75 })
				local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

				return MiniStatusline.combine_groups({
					{ hl = mode_hl,                  strings = { mode } },
					'%<', -- Mark general truncate point
					{ hl = 'MiniStatuslineFilename', strings = { "%f%m" } },
					{ hl = 'MiniStatuslineDevinfo',  strings = { git, diff, diagnostics } },
					'%=', -- End left alignment
					{ hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
					{ hl = mode_hl,                  strings = { search, location } },
				})
			end,
			inactive = function()
				return MiniStatusline.combine_groups({
					{ hl = "MiniStatuslineInactive", strings = { "%f%m" } },
				})
			end,
		},
	})
end)
later(function() require("mini.trailspace").setup() end)

now(function()
	vim.g.projectionist_heuristics = {
		["*.go"] = {
			["*.go"] = { alternate = "{}_test.go" },
			["*_test.go"] = { alternate = "{}.go" },
		}
	}
	add({ source = "tpope/vim-projectionist" })
end)

-- [[ Keymaps ]]
later(function()
	local map = vim.keymap.set
	MiniPick = require('mini.pick')
	MiniFiles = require('mini.files')
	map("n", "<Leader><CR>", ":nohlsearch|wa<CR><C-g>")
	map("n", "<Leader><Leader>", "<C-^>", { desc = "quick switch to previous buffer" })
	map("c", "%%", "<C-R>=expand('%:h').'/'<cr>", { desc = "expand current directory" })
	map("n", "<leader>s", ":A<CR>")
	-- add a line before/after
	map("n", "]<Space>", ":set paste<CR>m`o<Esc>``:set nopaste<CR>")
	map("n", "[<Space>", ":set paste<CR>m`O<Esc>``:set nopaste<CR>")
	-- Diagnostic keymaps
	map("n", "[e", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
	map("n", "]e", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
	map("n", "[q", ":cprevious<CR>", { desc = "Go to previous quickfix" })
	map("n", "]q", ":cnext<CR>", { desc = "Go to next quickfix" })
	-- Easier exit from terminal mode
	map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
	-- auto-insert when entering term buffer
	--  Use CTRL+<hjkl> to switch between windows
	map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
	map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
	map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
	map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
	map("n", "<leader>fm", ":vnew<CR><C-w>H:vnew<CR><C-w>L<C-w>h", { desc = "Enter [F]ocus [M]ode" })
	-- MiniPick
	map("n", "<leader><space>", MiniPick.builtin.files, { desc = 'Find File' })
	map("n", "<leader>bl", MiniPick.builtin.buffers, { desc = 'Search [B]uffer [L]ist' })
	map("n", "<leader>a", MiniPick.builtin.grep_live, { desc = 'Live Grep' })
	map("n", "<leader>A", function()
		MiniPick.builtin.grep({
			pattern = vim.fn.escape(vim.fn.expand '<cword>', [[\/]])
		})
	end, { desc = 'Search Current Word' })
	map("n", "<Leader>e", function()
		MiniPick.registry.files({ cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) })
	end, { desc = "[E]dit file in cwd" })
end)

now(function()
	add({
		source = "neovim/nvim-lspconfig",
		depends = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
	})

	local servers = {
		gopls = {
			settings = {
				gopls = {
					semanticTokens = true,
					experimentalPostfixCompletions = true,
					templateExtensions = { "tmpl" },
					hints = {
						functionTypeParameters = true,
						parameterNames = true,
					},
					vulncheck = "Imports",
					analyses = {
						fieldalignment = true,
						shadow = true,
						unusedparams = true,
						unusedvariable = true,
						unusedwrite = true,
						useany = true,
					},
					staticcheck = true,
				},
			},
		},
		golangci_lint_ls = {
			cmd = { "golangci-lint-langserver" },
			command = { "golangci-lint", "run", "--out-format", "json", "--issues-exit-code=1" },
		},
		gleam = {},
		tsserver = {},
		lua_ls = {
			settings = {
				Lua = {
					diagnostics = { globals = { 'vim' } },
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		},
	}
	require("lspconfig").gleam.setup({})
	require("mason").setup()
	require("mason-lspconfig").setup({
		handlers = {
			function(server_name)
				local server = servers[server_name] or {}
				require("lspconfig")[server_name].setup(server)
			end,
		},
	})
end)

now(function()
	add("nvim-treesitter/nvim-treesitter")
	require("nvim-treesitter.configs").setup({
		highlight = {
			enable = true,
		},
		ensure_installed = {
			"cue",
			"lua",
			"go",
			"typescript",
			"tsx",
		},
	})
end)


vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		map("<leader>di", vim.diagnostic.open_float, "[D][I]agnostic")

		map("gR", vim.lsp.buf.references, "[G]oto [R]eferences")
		map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
		map("gD", vim.lsp.buf.type_definition, "[G]oto [T]ype definition")
		map("K", vim.lsp.buf.hover, "Hover Documentation")

		map("<C-s>", vim.lsp.buf.signature_help, "Signature Help")
		vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help,
			{ buffer = event.buf, desc = "LSP: Signature Help" })


		if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
			end, "[T]oggle Inlay [H]ints")
		end
	end,

})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("format-prewrite", {}),
	pattern = "*",
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("format-prewrite", { clear = true }),
	pattern = "*.go",
	callback = function()
		vim.lsp.buf.format({ async = false })
		vim.lsp.buf.code_action({
			context = { diagnostics = {}, only = { "source.organizeImports" } },
			apply = true,
			async = false,
		})
	end,
})
