# openai.nvim

"Dead Simple OpenAI Plugin for Neovim"

A neovim plugin for requesting [code edit (Codex)](https://platform.openai.com/docs/guides/code) and [chat completion (ChatGPT)](https://platform.openai.com/docs/guides/chat).

Not feature-rich, just for testing and studying by myself.

## Usage

### Visual Mode

Grab a visual block and run commands:

| Command | Action |
| --- | --- |
| :OpenaiCodex | Replace selected block with the result of code edit. |
| :OpenaiComplete | Replace selected block with the result of chat completion. |

### Lua Function

```vim
:lua =require'openai'.edit_code([[Write a golang code which deletes all files and directories recursively.]])
:lua =require'openai'.complete_chat([[What is the answer to life, the universe, and everything?]])
```

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

## Todo

- [ ] Implement/add all API functions
  - [ ] [Models](https://platform.openai.com/docs/api-reference/models)
  - [ ] [Completions](https://platform.openai.com/docs/api-reference/completions)
  - [X] [Chat](https://platform.openai.com/docs/api-reference/chat)
  - [X] [Edits](https://platform.openai.com/docs/api-reference/edits)
  - [ ] [Images](https://platform.openai.com/docs/api-reference/images)
  - [ ] [Embeddings](https://platform.openai.com/docs/api-reference/embeddings)
  - [ ] [Audio](https://platform.openai.com/docs/api-reference/audio)
  - [ ] [Files](https://platform.openai.com/docs/api-reference/files)
  - [ ] [Fine-tunes](https://platform.openai.com/docs/api-reference/fine-tunes)
  - [ ] [Moderations](https://platform.openai.com/docs/api-reference/moderations)

## License

MIT

