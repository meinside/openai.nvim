# openai.nvim

"Dead Simple OpenAI Plugin for Neovim"

A neovim plugin for requesting [completion](https://platform.openai.com/docs/guides/completion), [code edit (Codex)](https://platform.openai.com/docs/guides/code) and [chat completion (ChatGPT)](https://platform.openai.com/docs/guides/chat).

Not feature-rich, just for testing and studying by myself.

## Usage

### Commands

| Command | Action |
| --- | --- |
| :OpenaiEdit | Fix grammar and spelling mistakes of the given text. |
| :OpenaiCodex | Generate code by the given text as an instruction. |
| :OpenaiComplete | Generate text by the given text as a prompt of chat completion. |

The response of API will be inserted in the current cursor position.

```vim
:OpenaiEdit wat iz ur name?
:OpenaiCodex create a clojure fibonacci function which is not recursive
:OpenaiComplete what is the answer to life, the universe, and everything?
```

Grab a visual block and run commands, then the selected block will be replaced with the response of API.

```vim
:'<,'>OpenaiEdit
:'<,'>OpenaiCodex
:'<,'>OpenaiComplete
```

### Lua Functions

It also can be run with lua:

```vim
:lua =require'openai'.edit({input = [[Wat iz ur name?]], instruction = [[Fix the grammar and spelling mistakes.]], return_only = true})
:lua =require'openai'.edit_code({instruction = [[Refactor this ruby code to a shorter one.]], input = [[a = 1\nb = 2\ntemp = a\na = b\nb = temp]], return_only = true})
:lua =require'openai'.complete_chat({input = [[What is the answer to life, the universe, and everything?]], return_only = true})
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
        --  edit = 'text-davinci-edit-001',
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
  - [X] [Completions](https://platform.openai.com/docs/api-reference/completions)
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

