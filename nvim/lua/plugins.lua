return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            transparent_background = true,
            background = {
                light = "latte",
                dark = "macchiato",
            },
            custom_highlights = function(colors)
                return {
                    LineNr = { fg = colors.subtext1 },
                    LineNrAbove = { fg = colors.overlay1 },
                    LineNrBelow = { fg = colors.overlay1 }
                }
            end,
            auto_integrations = true
        },
    },
    {
        "kj-1809/previous-buffer.nvim",
        config = function()
            vim.keymap.set("n", "<leader>,", ":PreviousBuffer<CR>", { silent = true })
        end,
    },
    {
        "nvim-pack/nvim-spectre",
        keys = {
            {
                "<leader>S",
                function()
                    require("spectre").toggle()
                end,
                desc = "Toggle Spectre"
            },
            {
                "<leader>sw",
                function()
                    require("spectre").open_visual({select_word = true})
                end,
                desc = "Search current word"
            },
            {
                "<leader>sw",
                function()
                    require("spectre").open_visual()
                end,
                mode = 'v',
                desc = "Search current word"
            },
            {
                "<leader>sp",
                function()
                    require("spectre").open_file_search({select_word = true})
                end,
                desc = "Search in current file"
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim"
        }
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = "Neotree",
        version = "^3.0",
        deactivate = function()
            vim.cmd([[Neotree close]])
        end,
        lazy = false,
        opts = {
            open_on_setup = true,
            event_handlers = {
                {
                    event = "neo_tree_buffer_enter",
                    handler = function(arg)
                        vim.opt.relativenumber = true
                    end,
                }
            },
            filesystem = {
                use_libuv_file_watcher = true,
                filtered_items = {
                    visible = true 
                },
                hijack_netrw_behaviour = 'open_current',
                window = {
                    mappings = {
                        ["<leader>p"] = "image_wezterm", -- " or another map
                    },
                },
            },
            commands = {
                image_wezterm = function(state)
                    local node = state.tree:get_node()
                    if node.type == "file" then
                        require("image_preview").PreviewImage(node.path)
                    end
                end,
            },
        },
        keys = {
            { "<leader>nt", function() vim.cmd("Neotree toggle") end,
                desc = "neo-tree: Toggle" }
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        }
    },
    {
        url = "https://codeberg.org/andyg/leap.nvim",
        lazy = false,
        dependencies = { "tpope/vim-repeat" },
        keys = {
            {
                "m",
                "<Plug>(leap)",
                mode = {"n", "x", "o"}
            },
            {
                "M",
                "<Plug>(leap-from-window)",
                mode = {"n", "x", "o"}
            }
        }
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        version = "^3.0",
        opts = {},
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    "folke/neodev.nvim",
    {
        "nvim-telescope/telescope.nvim",
        version = "0.2.1",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            {
                "<leader>pf",
                function()
                    require("telescope.builtin").find_files()
                end,
                desc = "Telescope: Find in files"
            },
            {
                "<leader>gf",
                function()
                    require("telescope.builtin").git_files()
                end,
                desc = "Telescope: Find in Git cache"
            }
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        branch = "main",
        opts = {

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,

            highlight = {
                -- `false` will disable the whole extension
                enable = true,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },
        },
        init = function()
            vim.api.nvim_create_autocmd('FileType', { 
                callback = function() 
                    -- Enable treesitter highlighting and disable regex syntax
                    pcall(vim.treesitter.start) 
                    -- Enable treesitter-based indentation
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" 
                end, 
            }) 
            local ensureInstalled = {
                "vimdoc",
                "swift",
                "javascript",
                "typescript",
                "c",
                "go",
                "zig",
                "lua",
                "rust",
                "cpp",
                "python",
                "qmljs",
                "qmldir",
                "gitcommit",
                "svelte",
                "pkl",
            }
            local alreadyInstalled = require('nvim-treesitter.config').get_installed()
            local parsersToInstall = vim.iter(ensureInstalled)
                :filter(function(parser)
                    return not vim.tbl_contains(alreadyInstalled, parser)
                end)
                :totable()
            require('nvim-treesitter').install(parsersToInstall)
        end,
    },
    {
        "mason-org/mason.nvim",
        version = "^2.0",
        opts = {}
    },
    {
        "mason-org/mason-lspconfig.nvim",
        version = "^2.0",
        opts = {
            ensure_installed = {
                "rust_analyzer",
                "phpactor",
                "gopls",
                "bashls",
                "clangd",
                "cssls",
                "marksman",
            }
        },
    },
    {
        "neovim/nvim-lspconfig",
        version = "^2.0",
        lazy = false
    },
    {
        "AlexandrosAlexiou/kotlin.nvim",
        ft = { "kotlin" },
        dependencies = {
            "mason.nvim",
            "mason-lspconfig.nvim",
            -- "oil.nvim",
            "trouble.nvim",
        },
        config = function()
            require("kotlin").setup {
                -- Optional: Specify root markers for multi-module projects
                root_markers = {
                    "gradlew",
                    ".git",
                    "mvnw",
                    "settings.gradle",
                },

                -- Optional: Java Runtime to run the kotlin-lsp server itself
                -- NOT REQUIRED when using Mason (kotlin-lsp v261+ includes bundled JRE)
                -- Priority: 1. jre_path, 2. Bundled JRE (Mason), 3. System java
                --
                -- Use this if you want to run kotlin-lsp with a specific Java version
                -- Must point to JAVA_HOME (directory containing bin/java)
                -- Examples:
                --   macOS:   "/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home"
                --   Linux:   "/usr/lib/jvm/java-21-openjdk"
                --   Windows: "C:\\Program Files\\Java\\jdk-21"
                --   Env var: os.getenv("JAVA_HOME") or os.getenv("JDK21")
                jre_path = nil,  -- Use bundled JRE (recommended)

                -- Optional: JDK for symbol resolution (analyzing your Kotlin code)
                -- This is the JDK that your project code will be analyzed against
                -- Different from jre_path (which runs the server)
                -- Required for: Analyzing JDK APIs, standard library symbols, platform types
                --
                -- Usually should match your project's target JDK version
                -- Examples:
                --   macOS:   "/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home"
                --   Linux:   "/usr/lib/jvm/java-17-openjdk"
                --   Windows: "C:\\Program Files\\Java\\jdk-17"
                --   SDKMAN:  os.getenv("HOME") .. "/.sdkman/candidates/java/17.0.8-tem"
                jdk_for_symbol_resolution = nil,  -- Auto-detect from project

                -- Optional: Specify additional JVM arguments for the kotlin-lsp server
                jvm_args = {
                    "-Xmx4g",  -- Increase max heap (useful for large projects)
                },

                -- Optional: Configure inlay hints (requires kotlin-lsp v261+)
                -- All settings default to true, set to false to disable specific hints
                inlay_hints = {
                    enabled = true,  -- Enable inlay hints (auto-enable on LSP attach)
                    parameters = true,  -- Show parameter names
                    parameters_compiled = true,  -- Show compiled parameter names
                    parameters_excluded = false,  -- Show excluded parameter names
                    types_property = true,  -- Show property types
                    types_variable = true,  -- Show local variable types
                    function_return = true,  -- Show function return types
                    function_parameter = true,  -- Show function parameter types
                    lambda_return = true,  -- Show lambda return types
                    lambda_receivers_parameters = true,  -- Show lambda receivers/parameters
                    value_ranges = true,  -- Show value ranges
                    kotlin_time = true,  -- Show kotlin.time warnings
                },
            }
        end,
    },
    {
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        dependencies = { "rafamadriz/friendly-snippets" },

        -- Use a release tag to download pre-built binaries
        version = "*",
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using the latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to VSCode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = {
                -- Each keymap may be a list of commands and/or functions
                preset = "enter",
                -- Select completions
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                -- Scroll documentation
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                -- Show/hide signature
                ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
                ["<C-S-K>"] = { "show", "hide", "fallback" }
            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            sources = {
                -- `lsp`, `buffer`, `snippets`, `path`, and `omni` are built-in
                -- so you don't need to define them in `sources.providers`
                default = { "lsp", "path", "snippets" },

                -- Sources are configured via the sources.providers table
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },
            completion = {
                -- The keyword should only match against the text before
                keyword = { range = "prefix" },
                menu = {
                    -- Use treesitter to highlight the label text for the given list of sources
                    draw = {
                        treesitter = { "lsp" },
                    },
                },
                -- Show completions after typing a trigger character, defined by the source
                trigger = { show_on_trigger_character = true },
                documentation = {
                    -- Show documentation automatically
                    auto_show = true,
                },
            },

            -- Signature help when tying
            signature = { enabled = true },
        },
        opts_extend = { "sources.default" },
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function () require("harpoon").setup({}) end,
        keys = {
            { "<leader>hh", function() require("harpoon"):list():add() end,
                desc = "Harpoon: Add to list" },
            { "<C-z>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
                desc = "Harpoon: Open list" },
            { "<leader>1", function() require("harpoon"):list():select(1) end,
                desc = "Harpoon: Jump to list item 1" },
            { "<leader>2", function() require("harpoon"):list():select(2) end,
                desc = "Harpoon: Jump to list item 2" },
            { "<leader>3", function() require("harpoon"):list():select(3) end,
                desc = "Harpoon: Jump to list item 3" },
            { "<leader>4", function() require("harpoon"):list():select(4) end,
                desc = "Harpoon: Jump to list item 4" },
            { "<leader>5", function() require("harpoon"):list():select(5) end,
                desc = "Harpoon: Jump to list item 5" },
            { "<leader>6", function() require("harpoon"):list():select(6) end,
                desc = "Harpoon: Jump to list item 6" },
            { "<leader>7", function() require("harpoon"):list():select(7) end,
                desc = "Harpoon: Jump to list item 7" },
            { "<leader>8", function() require("harpoon"):list():select(8) end,
                desc = "Harpoon: Jump to list item 8" },
            { "<leader>9", function() require("harpoon"):list():select(9) end,
                desc = "Harpoon: Jump to list item 9" },
        },
    },
    {
        "mbbill/undotree",
        version = "^6.0",
        keys = {
            { "<leader>u", vim.cmd.UndotreeToggle, desc = "Open undo tree" },
        },
    },
    {
        "tpope/vim-fugitive",
        version = "^3.0",
        keys = {
            {
                "<leader>gds",
                "<cmd>Gvdiffsplit<CR>",
                desc = [[Show staged and working tree versions of the
                file side by side]],
            },
            { "<leader>gl", "<cmd>G log<CR>", desc = "Git log" },
            { "<leader>gs", "<cmd>G<CR>", desc = "Git status" },
            { "<leader>gp", "<cmd>G push<CR>", desc = "Git push" },
            { "<leader>gfp", "<cmd>G push --force<CR>", desc = "Git force push" },
            { "<leader>gP", "<cmd>G pull<CR>", desc = "Git pull" },
        },
    },
    "tpope/vim-rhubarb",
    { "tpope/vim-commentary", version = "^1.0" },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
        opts = {
            options = {
                theme = "auto",
                section_separators = {
                    right = "",
                    left = ""
                },
            },
            sections = {
                lualine_c = { "filename", "selectioncount", "searchcount" },
                lualine_x = {"lsp_status", "encoding", "fileformat", "filetype"},
                lualine_y = {
                    "location"
                },
                lualine_z = {
                    function ()
                        return os.date("%a %d/%m %H:%M:%S", os.time())
                    end
                }
            }
        }
    },
    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        tag = "stable",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
    {
        "folke/trouble.nvim",
        version = "3.7.1",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
    "theprimeagen/vim-be-good",
    {
        "Bekaboo/dropbar.nvim",
        version = "^14.0",
        dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
    },
    {
        "folke/todo-comments.nvim",
        version = "^1.0",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            keywords = {
                SAFETY = { icon = " ", color = "hint" },
                UNSAFE = { icon = " ", color = "error" }
            }
        },
        lazy = false,
        keys = {
            { "<leader>tdt", "<cmd>Trouble todo<CR>", desc = "Todo: Open in Trouble" },
            { "<leader>tts", "<cmd>TodoTelescope<CR>", desc = "Todo: Open in Telescope" },
        },
    },
    {
        "m4xshen/autoclose.nvim",
        opts = {}
    },
    {
        "lewis6991/gitsigns.nvim",
        version = "~2.1",
        opts = {
            current_line_blame = true,
        },
    },
    {
        'jedrzejboczar/nvim-dap-cortex-debug',
        opts = {},
        dependencies = {'mfussenegger/nvim-dap'}
    },
    {
        "mfussenegger/nvim-dap",
        -- version = "~0.10",
        config = function(_, _)
            local dap = require("dap")

            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = "/usr/local/bin/codelldb",
                    args = {
                        "--port",
                        "${port}",
                        "--liblldb",
                        "/usr/local/opt/llvm/lib/liblldb.dylib",
                    },
                },
            }

            local codelldbConf = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    lldb = {
                        library = "/usr/local/opt/llvm/lib/liblldb.dylib",
                    },
                },
            }

            dap.configurations.cpp = codelldbConf
            dap.configurations.c = codelldbConf
        end,
        keys = {
            { "<leader>dn", function () require("dap").new() end,
                desc = "DAP: New session" },
            { "<leader>dc", function () require("dap").continue() end,
                desc = "DAP: Continue execution" },
            { "<leader>dp", function () require("dap").pause() end,
                desc = "DAP: Pause execution" },
            { "<leader>ddc", function()
                local dap = require("dap")
                dap.disconnect()
                dap.close()
            end, desc = "DAP: Disconnect and close session" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end,
                desc = "DAP: Toggle breakpoint" },
            { "<leader>dsi", function() require("dap").step_into() end,
                desc = "DAP: Step into" },
            { "<leader>dso", function() require("dap").step_over() end,
                desc = "DAP: Step over" },
            { "<leader>dr", function() require("dap").repl.open() end,
                desc = "DAP: Open REPL" },
        }
    },
    {
        "igorlfs/nvim-dap-view",
        opts = {},
        keys = {
            {
                "<leader>du",
                function()
                    require("dap-view").toggle()
                end,
                desc = "DAP: Toggle DAP View"
            }
        }
    },
    "jay-babu/mason-nvim-dap.nvim",
    {
        "yorickpeterse/nvim-window",
        keys = {
            {
                "<A-w>",
                function()
                    require("nvim-window").pick()
                end,
                desc = "Open window picker"
            },
        },
    },
    {
        "petertriho/nvim-scrollbar",
        config = function()
            require("scrollbar").setup({
                show_in_active_only = true,
                -- set_highlights = true,
            })
        end,
    },
    {
        'stevearc/aerial.nvim',
        opts = {
            on_attach = function(bufnr)
                -- Jump forwards/backwards with '{' and '}'
                vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
                vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
            end,
        },
        -- Optional dependencies
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        }
    },
    {
        "chrisgrieser/nvim-origami",
        event = "VeryLazy",
        opts = {}, -- required even when using default config

        -- recommended: disable vim's auto-folding
        init = function()
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
        end,
    },
    {
        "josstei/whisk.nvim",
        event = "VeryLazy",
        opts = {
            cursor = {
                enabled = false,
            },
            scroll = {
                duration = 150,
                easing = "ease-in-out",
                enabled = true,
            },
            keymaps = {
                cursor = true,
                scroll = true,
            },
            performance = {
                enabled = false,
                disable_syntax_during_scroll = true,
                ignore_events = { "WinScrolled", "CursorMoved", "CursorMovedI" },
                reduce_frame_rate = false,
                frame_rate_threshold = 60,    -- not currently read by any code path
                auto_enable_on_large_files = true,
                large_file_threshold = 5000,
            },
        }
    },
    {
        'adelarsq/image_preview.nvim',
        event = 'VeryLazy',
        config = function()
            require("image_preview").setup({})
        end
    },
}
