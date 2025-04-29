{ pkgs, ...}: {
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

        vim.opt.number = true

        vim.diagnostic.config {
          virtual_lines = {
            current_line = true,
          },
        }
      '';

      plugins = with pkgs.vimPlugins; [
        vim-cool
        {
          plugin = nvim-treesitter.withAllGrammars;
          type   = "lua";
          config = ''
            require("nvim-treesitter.configs").setup {
              highlight = { enable = true },
              indent    = { enable = true },
            }
          '';
        }
        {
          plugin = nvim-lspconfig;
          type   = "lua";
          config = ''
            vim.lsp.enable {
              "gleam",
              "nil_ls",
            }
          '';
          runtime = {
            "after/ftplugin/nix.lua".text = ''
              vim.opt.tabstop     = 2
              vim.opt.shiftwidth  = 2
							vim.opt.softtabstop = 2
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
