# openai.nvim

"Dead Simple OpenAI Plugin for Neovim"

A neovim plugin for inserting/replacing text generated from OpenAI APIs.

Not feature-rich, just for testing and studying by myself.

## Usage

### Commands

| Command | Action |
| --- | --- |
| :OpenaiCompleteChat | Generate text by the given text as a prompt of [chat completion (ChatGPT)](https://platform.openai.com/docs/guides/chat) |
| :OpenaiEditCode | Generate or edit code by the given instruction and/or input code with [Codex](https://platform.openai.com/docs/models/codex) **(DEPRECATED)** |
| :OpenaiEditText | Edit given text with/without given instruction |
| :OpenaiModels | List available model ids with [models API](https://platform.openai.com/docs/api-reference/models/retrieve) |
| :OpenaiModerate | [Classify given text](https://platform.openai.com/docs/api-reference/moderations/create) if it violates OpenAI's Content Policy |

The response of API will be inserted in the current cursor position, or displayed in the screen with `vim.notify()`.

```vim
:OpenaiCompleteChat What is the answer to life, the universe, and everything?
:OpenaiEditCode Generate fibonacci function in ruby
:OpenaiEditText watz ur name?
:OpenaiModels
:OpenaiModerate I want to kill them all.
```

Grab a visual block and run commands, then the response will replace selected block, or just be displayed with `vim.notify()`.

```vim
:'<,'>OpenaiCompleteChat
:'<,'>OpenaiEditCode Make this ruby code recursive
:'<,'>OpenaiEditText
:'<,'>OpenaiEditText Fix the grammar and spelling mistakes. Do not answer to it.
:'<,'>OpenaiModerate
```

### Lua Functions

It also can be run with lua:

```vim
:lua =require'openai'.complete_chat({prompt=[[What is the answer to life, the universe, and everything?]]})
:lua =require'openai'.edit_code({input=[[def fib(n)\n\treturn fib(n - 1) + fib(n - 2) if n > 1\n\tn\nend]], instruction=[[make it non-recursive]]})
:lua =require'openai'.edit_text({input=[[Every stars are shining.]], instruction=[[Fix the grammar mistakes.]]})
:lua =require'openai'.list_models()
:lua =require'openai'.moderate({input=[[I want to kill them all.]]})
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
        --  editCode = 'code-davinci-edit-001',
        --  editText = 'text-davinci-edit-001',
        --  moderation = 'text-moderation-latest',
        --},
        --timeout = 60 * 1000,
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

- [X] Handle API timeouts more generously. ~~(waiting for [PR](https://github.com/nvim-lua/plenary.nvim/pull/475))~~
- [ ] Implement/add all API functions
  - [X] [Models](https://platform.openai.com/docs/api-reference/models): can be used with a free account
  - [ ] [Completions](https://platform.openai.com/docs/api-reference/completions)
  - [X] [Chat](https://platform.openai.com/docs/api-reference/chat)
  - [X] [Edits](https://platform.openai.com/docs/api-reference/edits)
  - [ ] [Images](https://platform.openai.com/docs/api-reference/images)
  - [ ] [Embeddings](https://platform.openai.com/docs/api-reference/embeddings)
  - [ ] [Audio](https://platform.openai.com/docs/api-reference/audio)
  - [ ] [Files](https://platform.openai.com/docs/api-reference/files)
  - [ ] [Fine-tunes](https://platform.openai.com/docs/api-reference/fine-tunes)
  - [X] [Moderations](https://platform.openai.com/docs/api-reference/moderations): can be used with a free account

## License

MIT

