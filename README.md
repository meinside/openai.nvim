# openai.nvim

"Dead Simple OpenAI Plugin for Neovim"

A neovim plugin for inserting/replacing text generated from OpenAI APIs.

Not feature-rich, just for testing and studying by myself.

## Usage

### Commands

| Command | Action |
| --- | --- |
| :OpenaiCompleteChat | Generate text by the given text as a prompt of [chat completion (ChatGPT)](https://platform.openai.com/docs/guides/chat) |
| :OpenaiModerate | [Classify given text](https://platform.openai.com/docs/api-reference/moderations/create) if it violates OpenAI's Content Policy |

The response of API will be inserted in the current cursor position, or displayed in the screen with `vim.notify()`.

```vim
:OpenaiCompleteChat what is the answer to life, the universe, and everything?
```

Grab a visual block and run commands, then the selected block will be replaced with the response of API.

```vim
:'<,'>OpenaiCompleteChat
:'<,'>OpenaiModerate
```

### Lua Functions

It also can be run with lua:

```vim
:lua =require'openai'.complete_chat({prompt = [[What is the answer to life, the universe, and everything?]]})
:lua =require'openai'.moderate({input = [[I want to kill them all.]]})
```

## Install

### lazy.nvim

```lua
{
    'meinside/openai.nvim',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
    config = function()
      require'openai'.setup {
        -- NOTE: these are default values:

        --credentialsFilepath = '~/.config/openai-nvim.json',
        --models = {
        --  completeChat = 'gpt-3.5-turbo',
        --  moderation = 'text-moderation-latest',
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

- [ ] Handle API timeouts more generously. (times out in 10 seconds for now, waiting for [PR](https://github.com/nvim-lua/plenary.nvim/pull/475))
- [ ] Implement/add all API functions
  - [ ] [Models](https://platform.openai.com/docs/api-reference/models)
  - [X] ~~[Completions](https://platform.openai.com/docs/api-reference/completions)~~ (`text-davinci-edit-001` not working since 2023.03.24.)
  - [X] [Chat](https://platform.openai.com/docs/api-reference/chat)
  - [X] ~~[Edits](https://platform.openai.com/docs/api-reference/edits)~~ (`code-davinci-edit-001` not working since 2023.03.24, related to ['Codex API is discontinued'](https://news.ycombinator.com/item?id=35242069)?)
  - [ ] [Images](https://platform.openai.com/docs/api-reference/images)
  - [ ] [Embeddings](https://platform.openai.com/docs/api-reference/embeddings)
  - [ ] [Audio](https://platform.openai.com/docs/api-reference/audio)
  - [ ] [Files](https://platform.openai.com/docs/api-reference/files)
  - [ ] [Fine-tunes](https://platform.openai.com/docs/api-reference/fine-tunes)
  - [X] [Moderations](https://platform.openai.com/docs/api-reference/moderations)

## License

MIT

