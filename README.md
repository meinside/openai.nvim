# openai.nvim

"Dead Simple OpenAI Plugin for Neovim"

A neovim plugin for requesting [code edit (Codex)](https://platform.openai.com/docs/guides/code) and [chat completion (ChatGPT)](https://platform.openai.com/docs/guides/chat).

Not feature-rich, just for testing and studying by myself.

## Usage

Grab a visual block and run commands:

| Command | Action |
| --- | --- |
| :OpenaiCodex | Replace selected block with the result of code edit. |
| :OpenaiComplete | Replace selected block with the result of chat completion. |

## Install

### lazy.nvim

```lua
{
    'meinside/openai.nvim',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
    config = function()
      require'openai'.setup {
        -- NOTE: default values:

        --credentialsFilepath = '~/.config/openai-nvim.json',
        --models = {
        --  editCode = 'code-davinci-edit-001',
        --  completeChat = 'gpt-3.5-turbo',
        --},
      }
    end,
},
```

## Configuration

Create `openai-nvim.json` file in `~/.config/`:

```json
{
  "api_key": "sk-abcdefgHIJKLMNOP0123456789",
  "org_id": "org-0987654321qrstuvwXYZ"
}
```

## License

MIT

