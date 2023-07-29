local api = vim.api
local f = vim.fn
local time_out = vim.o.timeoutlen
local key_presses = 0
local previous_key = nil
local previous_time = 0
local function handle(key, max_presses, substitute)
  local current_time = (f.reltimefloat(f.reltime()) * 1000)
  local elapsed = (current_time - previous_time)
  local normal
  local function _1_(key0)
    return vim.cmd(string.format("normal! %s%s", vim.v.count1, key0))
  end
  normal = _1_
  if ((key ~= previous_key) or (elapsed > time_out)) then
    key_presses = 1
    previous_time = current_time
    previous_key = key
    return normal(key)
  elseif (key_presses < max_presses) then
    key_presses = (key_presses + 1)
    return normal(key)
  elseif (key_presses >= max_presses) then
    key_presses = 0
    previous_time = 0
    previous_key = nil
    local _2_ = type(substitute)
    if (_2_ == "function") then
      return substitute()
    elseif (_2_ == "string") then
      local _let_3_ = api.nvim_get_mode()
      local mode = _let_3_["mode"]
      local _4_ = f.maparg(substitute, mode, false, true)
      if ((_G.type(_4_) == "table") and (nil ~= (_4_).callback)) then
        local callback = (_4_).callback
        return callback()
      elseif ((_G.type(_4_) == "table") and (nil ~= (_4_).rhs)) then
        local rhs = (_4_).rhs
        local success, result = pcall(api.nvim_eval, rhs)
        if not success then
          return print(string.format("Error: %s", result))
        else
          return nil
        end
      else
        return nil
      end
    else
      return nil
    end
  else
    return nil
  end
end
local function _9_(maps, mode, max_presses)
  for key, action in pairs(maps) do
    local function _10_()
      return handle(key, max_presses, action)
    end
    vim.keymap.set(mode, key, _10_, {noremap = true})
  end
  return nil
end
return _9_
