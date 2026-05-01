local notes = require("notes")

local function detect(line, col)
  local before = line:sub(1, col)
  local pos = before:match(".*()%[%[")
  if pos then
    local after = before:sub(pos + 2)
    if not after:find("%]%]", 1, true) then return "wikilink", after, pos + 1 end
  end
  local hpos, partial = before:match("()#([%w_/%-]*)$")
  if hpos and (hpos == 1 or before:sub(hpos - 1, hpos - 1):match("%s")) then
    return "tag", partial, hpos
  end
end

local function segments(partial, pool)
  local prefix, s = "", partial:find("/[^/]*$")
  if s then prefix = partial:sub(1, s) end
  local seen, out = {}, {}
  for item in pairs(pool) do
    if item:sub(1, #prefix) == prefix and #item > #prefix then
      local rest = item:sub(#prefix + 1)
      local n = rest:find("/")
      if n then
        local seg = prefix .. rest:sub(1, n)
        if not seen[seg] then seen[seg] = true; table.insert(out, { text = seg, branch = true }) end
      else
        if not seen[item] then seen[item] = true; table.insert(out, { text = item, branch = false }) end
      end
    end
  end
  return out
end

local source = {}
function source.new() return setmetatable({}, { __index = source }) end
function source:get_trigger_characters() return { "[", "#", "/" } end

function source:get_completions(ctx, callback)
  notes.ensure()
  local kind, partial, pstart = detect(ctx.line, ctx.cursor[2])
  if not kind then
    callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = {} })
    return function() end
  end

  local has_close = false
  if kind == "wikilink" then
    local after = ctx.line:sub(ctx.cursor[2] + 1)
    local cp, op = after:find("%]%]"), after:find("%[%[")
    has_close = cp and (not op or cp < op)
  end

  local pool = (kind == "wikilink") and notes.cache.links or notes.cache.tags
  local results = segments(partial, pool)

  local ok, types = pcall(require, "blink.cmp.types")
  local CIK = ok and types.CompletionItemKind or { Folder = 19, Reference = 18 }

  local items = {}
  for _, r in ipairs(results) do
    local newText
    if kind == "wikilink" then
      newText = (r.branch or has_close) and r.text or (r.text .. "]]")
    else newText = r.text end
    table.insert(items, {
      label = r.text, insertText = newText,
      kind = r.branch and CIK.Folder or CIK.Reference,
      textEdit = { newText = newText, range = {
        start = { line = ctx.cursor[1] - 1, character = pstart },
        ["end"] = { line = ctx.cursor[1] - 1, character = ctx.cursor[2] },
      }},
    })
  end
  callback({ is_incomplete_forward = true, is_incomplete_backward = true, items = items })
  return function() end
end

return source
