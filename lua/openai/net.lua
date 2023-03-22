-- lua/openai/net.lua

-- dependencies
local plenary = require'plenary/curl'

-- plugin modules
local fs = require'openai/fs'

-- constants
local baseurl = 'https://api.openai.com'
local contentType = 'application/json'

local M = {}

-- generate a request url
function M.openai_request_url(endpoint)
  return baseurl .. '/' .. endpoint
end

-- send http post request
function M.post(endpoint, params)
  local apiKey, orgId = M.openai_credentials()

  if apiKey == nil or orgId == nil then
    local err = 'No "api_key" or "org_id" value in config file: ' .. fs.ConfigFilepath
    return nil, err
  end

  return plenary.post(M.openai_request_url(endpoint), {
    headers = {
      ['Content-Type'] = contentType,
      ['Authorization'] = 'Bearer ' .. apiKey,
      ['OpenAI-Organization'] = orgId,
    },
    raw_body = vim.json.encode(params),
  }), nil
end

-- parse response and callback with the first choice
function M.on_choice(response, fn)
  local err = nil

  if response then
    local body = response.body or '{}'
    local parsed = vim.json.decode(body)
    if response.status == 200 then
      if parsed.choices and #parsed.choices > 0 then
        fn(parsed.choices[1])
      else
        err = 'There was no usable answer from OpenAI API.'
      end
    else
      err = 'Error from OpenAI: ' .. vim.inspect(parsed)
    end
  end

  return err
end

return M

