{ pkgs, lib, ...}: {
  home = {
    stateVersion = "25.05";

    file = {
      ".zshrc".source                 = ./dotfiles/.zshrc;
      ".config/ghostty/config".source = ./dotfiles/.config/ghostty/config;
    };

    packages = [
      pkgs.difftastic
      pkgs.eza
      pkgs.fd
      pkgs.lazygit
      pkgs.nil
      pkgs.ripgrep
      pkgs.tealdeer
      pkgs.xh
    ];
  };

  programs = {
    fish = {
      enable = true;

      shellAbbrs = {
        ls  = "exa -l";
        dev = "nix develop -c fish";
      };

      interactiveShellInit = ''
        set -g fish_greeting
        set -x SSH_AUTH_SOCK ~/.1password/agent.sock

        source ~/.orbstack/shell/init2.fish 2>/dev/null || :
      '';
    };

    git = {
      enable = true;
    };

    helix = {
      enable = true;

      settings = {
        theme = "flexoki_light";
      };
    };

    neovim = {
      enable        = true;
      defaultEditor = true;

      extraLuaConfig = ''
        vim.g.mapleader = " "

        vim.diagnostic.config {
          virtual_lines = {
            current_line = true,
          },
        }
      '';

      plugins = let
        fromGitHub = rev: ref: repo: pkgs.vimUtils.buildVimPlugin {
          pname = "${lib.strings.sanitizeDerivationName repo}";
          version = ref;
          src = builtins.fetchGit {
            url = "https://github.com/${repo}.git";
            ref = ref;
            rev = rev;
          };
        };
      in with pkgs.vimPlugins; [
        vim-cool
        {
          plugin = (fromGitHub "079554c242a86be5d1a95598c7c6368d6eedd7a3" "main" "nuvic/flexoki-nvim");
          type   = "lua";
          config = ''
            require("flexoki").setup { }

            vim.cmd("colorscheme flexoki")
          '';
        }
        {
          plugin = lazygit-nvim;
          type   = "lua";
          config = ''
            vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", {
              desc = "Open lazy git",
            })
          '';
        }
        {
          plugin = neogit;
          type   = "lua";
          config = ''
            require("neogit").setup {

            }

            vim.keymap.set("n", "<leader>gn", ":Neogit<CR>", {
              desc = "Open neogit",
            })
          '';
        }
        {
          plugin = nvim-treesitter.withAllGrammars;
          type   = "lua";
          config = ''
            require("nvim-treesitter.configs").setup {
              highlight = { enable = true },
            }
          '';
        }
        {
          plugin = nvim-lspconfig;
          type   = "lua";
          config = ''
            vim.lsp.enable {
              "rust_analyzer",
              "gleam",
              "nil_ls",
            }

            vim.api.nvim_create_autocmd("LspAttach", {
              callback = function(args)
                local opts = {
                  buffer  = args.buffer,
                  noremap = true,
                  silent  = true,
                }

                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
              end,
            })
          '';
          runtime = {
            "after/ftplugin/nix.lua".text = ''
              vim.opt.tabstop     = 2
              vim.opt.shiftwidth  = 2
              vim.opt.softtabstop = 2
              vim.opt.expandtab   = true
            '';
            "after/ftplugin/gleam.lua".text = ''
              vim.opt.tabstop     = 2
              vim.opt.shiftwidth  = 2
              vim.opt.softtabstop = 2
              vim.opt.expandtab   = true
            '';
            "after/ftplugin/go.lua".text = ''
              vim.opt.tabstop     = 4
              vim.opt.shiftwidth  = 4
            '';
            "after/ftplugin/make.lua".text = ''
              vim.opt.tabstop     = 4
              vim.opt.shiftwidth  = 4
            '';
            "after/ftplugin/html.lua".text = ''
              vim.opt.tabstop     = 4
              vim.opt.shiftwidth  = 4
              vim.opt.softtabstop = 4
              vim.opt.expandtab   = true
            '';
            "after/ftplugin/htmldjango.lua".text = ''
              vim.opt.tabstop     = 4
              vim.opt.shiftwidth  = 4
              vim.opt.softtabstop = 4
              vim.opt.expandtab   = true
            '';
          };
        }
        {
          plugin = oil-nvim;
          type   = "lua";
          config = ''
            require("oil").setup {
              view_options = {
                show_hidden = true
              }
            }

            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
          '';
        }
        {
          plugin = mini-ai;
          type   = "lua";
          config = ''
            require("mini.ai").setup {

            }
          '';
        }
        {
          plugin = mini-align;
          type   = "lua";
          config = ''
            require("mini.align").setup {

            }
          '';
        }
        {
          plugin = mini-basics;
          type   = "lua";
          config = ''
            require("mini.basics").setup {

            }
          '';
        }
        {
          plugin = mini-bracketed;
          type   = "lua";
          config = ''
            require("mini.bracketed").setup {

            }
          '';
        }
        {
          plugin = mini-clue;
          type   = "lua";
          config = ''
            MiniClue = require("mini.clue")
            MiniClue.setup {
              triggers = {
                -- Leader triggers
                { mode = 'n', keys = '<Leader>' },
                { mode = 'x', keys = '<Leader>' },

                -- Built-in completion
                { mode = 'i', keys = '<C-x>' },

                -- 'g' key
                { mode = 'n', keys = 'g' },
                { mode = 'x', keys = 'g' },
              },
              window = {
                delay = 0,
              },
            }
          '';
        }
        {
          plugin = mini-comment;
          type   = "lua";
          config = ''
            require("mini.comment").setup {

            }
          '';
        }
        {
          plugin = mini-completion;
          type   = "lua";
          config = ''
            require("mini.completion").setup {
              fallback_action = "",
            }
          '';
        }
        {
          plugin = mini-icons;
          type   = "lua";
          config = ''
            require("mini.icons").setup {

            }
          '';
        }
        {
          plugin = mini-indentscope;
          type   = "lua";
          config = ''
            require("mini.indentscope").setup {

            }
          '';
        }
        {
          plugin = mini-pick;
          type   = "lua";
          config = ''
            MiniPick = require("mini.pick")
            MiniPick.setup { }

            vim.keymap.set("n", "<leader>pf", function()
              MiniPick.builtin.files()
            end, {
              desc = "Pick files",
            })

            vim.keymap.set("n", "<leader>pb", function()
              MiniPick.builtin.buffers()
            end, {
              desc = "Pick buffers",
            })

            vim.keymap.set("n", "<leader>pg", function()
              MiniPick.builtin.grep_live()
            end, {
              desc = "Pick grep",
            })
          '';
        }
        {
          plugin = mini-splitjoin;
          type   = "lua";
          config = ''
            require("mini.splitjoin").setup {

            }
          '';
        }
        {
          plugin = mini-statusline;
          type   = "lua";
          config = ''
            require("mini.statusline").setup {

            }
          '';
        }
        {
          plugin = mini-surround;
          type   = "lua";
          config = ''
            require("mini.surround").setup {

            }
          '';
        }
        {
          plugin = mini-tabline;
          type   = "lua";
          config = ''
            require("mini.tabline").setup {

            }
          '';
        }
        {
          plugin = mini-trailspace;
          type   = "lua";
          config = ''
            require("mini.trailspace").setup {

            }
          '';
        }
      ];
    };
  };
}
