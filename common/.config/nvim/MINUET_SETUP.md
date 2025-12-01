# Minuet AI Auto-Complete Setup

## Configuration

Minuet is configured to use Claude (Anthropic) for AI-powered code completion through nvim-cmp.

### Provider Settings
- **Model**: claude-3-5-sonnet-20241022
- **Timeout**: 3 seconds
- **Context Window**: 16,000 characters
- **Completions**: 3 suggestions

## Keymaps

### nvim-cmp Navigation (Ctrl-based)
- `<C-n>` - Next completion item
- `<C-p>` - Previous completion item
- `<C-y>` - Accept selected completion
- `<CR>` - Accept selected completion (Enter)
- `<C-e>` - Dismiss/abort completion
- `<C-Space>` - Manually trigger completion
- `<Tab>` - Next item (also works)
- `<Shift-Tab>` - Previous item (also works)

### Documentation
- `<C-f>` - Scroll docs forward
- `<C-b>` - Scroll docs backward

## Setup Requirements

### API Key
Set your Anthropic API key as an environment variable:

```bash
export ANTHROPIC_API_KEY='your-api-key-here'
```

Add this to your `~/.zshrc` or `~/.bashrc`:

```bash
# For Minuet AI completion
export ANTHROPIC_API_KEY='sk-ant-...'
```

### Installation
The plugin is already configured in your `plugins.lua`. To install:

1. Open Neovim
2. Run `:Lazy sync` to install/update plugins
3. Restart Neovim

## Usage

### Auto-Completion
Auto-completion is enabled by default. As you type, Minuet will suggest completions automatically through nvim-cmp.

AI completions appear in the completion menu with the source shown as `[minuet]`.

### Manual Completion
Press `<C-Space>` to manually trigger completions at any time.

### Toggle Auto-Completion
To temporarily disable/enable auto-completion:

```vim
:Minuet cmp toggle
```

## Commands

- `:Minuet change_provider <provider>` - Switch AI provider (e.g., openai, gemini, codestral)
- `:Minuet change_model` - Change both provider and model
- `:Minuet cmp enable` - Enable auto-completion
- `:Minuet cmp disable` - Disable auto-completion
- `:Minuet cmp toggle` - Toggle auto-completion

## Completion Sources Priority

1. **minuet** - AI completions (Claude)
2. **nvim_lsp** - Language server completions
3. **luasnip** - Snippets
4. **buffer** - Buffer text completions

## Performance Settings

- **Throttle**: 1000ms - Rate limiting to avoid excessive API calls
- **Debounce**: 400ms - Wait time before triggering completion
- **Request Timeout**: 3s - Fast response timeout

## Troubleshooting

### No completions appearing
1. Check API key is set: `echo $ANTHROPIC_API_KEY`
2. Check Minuet status: `:checkhealth`
3. Try manual completion: `<C-Space>`

### Slow completions
1. Reduce `n_completions` in config (currently 3)
2. Decrease `context_window` (currently 16000)
3. Increase `debounce` time (currently 400ms)

### Too many completions
Run `:Minuet cmp disable` to disable auto-completion and use manual mode only.

## Alternative Providers

To switch to a different provider, edit `common/.config/nvim/lua/config/plugins.lua`:

```lua
provider = 'gemini',  -- Free and fast alternative
-- or
provider = 'codestral',  -- Specialized for code
-- or
provider = 'openai',  -- GPT models
```

Don't forget to set the corresponding API key environment variable.
