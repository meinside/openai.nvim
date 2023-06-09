-- lua/openai/net.lua
--
-- last update: 2023.04.13.

-- external dependencies
local curl = require'plenary/curl'

-- plugin modules
local fs = require'openai/fs'
local config = require'openai/config'

-- constants
local baseurl = 'https://api.openai.com'
local contentType = 'application/json'

local M = {}

-- generate a request url
local function openai_request_url(endpoint)
  return baseurl .. '/' .. endpoint
end

-- send http get request
function M.get(endpoint, params)
  local apiKey, orgId = fs.openai_credentials()

  if apiKey == nil or orgId == nil then
    local err = 'No "api_key" or "org_id" value in config file: ' .. config.options.credentialsFilepath
    return nil, err
  end

  return curl.get(openai_request_url(endpoint), {
    headers = {
      ['Content-Type'] = contentType,
      ['Authorization'] = 'Bearer ' .. apiKey,
      ['OpenAI-Organization'] = orgId,
    },
    query = params,
    timeout = config.options.timeout,
  }), nil
end

-- send http post request
function M.post(endpoint, params)
  local apiKey, orgId = fs.openai_credentials()

  if apiKey == nil or orgId == nil then
    local err = 'No "api_key" or "org_id" value in config file: ' .. config.options.credentialsFilepath
    return nil, err
  end

  return curl.post(openai_request_url(endpoint), {
    headers = {
      ['Content-Type'] = contentType,
      ['Authorization'] = 'Bearer ' .. apiKey,
      ['OpenAI-Organization'] = orgId,
    },
    raw_body = vim.json.encode(params),
    timeout = config.options.timeout,
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

-- parse response and callback with the models
function M.on_models(response, fn)
  local err = nil

  if response then
    local body = response.body or '{}'
    local parsed = vim.json.decode(body)
    if response.status == 200 then
      if parsed.data and #parsed.data > 0 then
        fn(parsed.data)
      else
        err = 'There was no returned model from OpenAI API.'
      end
    else
      err = 'Error from OpenAI: ' .. vim.inspect(parsed)
    end
  end

  return err
end

-- parse response and callback with the first moderation result
function M.on_moderation(response, fn)
  local err = nil

  if response then
    local body = response.body or '{}'
    local parsed = vim.json.decode(body)
    if response.status == 200 then
      if parsed.results and #parsed.results > 0 then
        fn(parsed.results[1])
      else
        err = 'There was no usable moderation result from OpenAI API.'
      end
    else
      err = 'Error from OpenAI: ' .. vim.inspect(parsed)
    end
  end

  return err
end

return M

