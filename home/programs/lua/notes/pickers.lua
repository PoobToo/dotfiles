local M = {}
local notes = require("notes")
local fzf = require("fzf-lua")

local function entry_of(b)
  local snip = b.snippet or ""
  if #snip > 80 then snip = snip:sub(1, 80) .. "…" end
  return string.format("%s:%d:1:[%s] %s", b.relpath, b.start_line, b.header, snip)
end

local function open_action(sel)
  local e = sel and sel[1]; if not e then return end
  local rel, line = e:match("^([^:]+):(%d+):")
  if rel then
    vim.cmd("edit +" .. line .. " " .. vim.fn.fnameescape(notes.dir .. "/" .. rel))
  end
end

local function show_blocks(blocks, prompt)
  if #blocks == 0 then vim.notify("No matching blocks", vim.log.levels.INFO); return end
  local items = {}
  for _, b in ipairs(blocks) do table.insert(items, entry_of(b)) end
  fzf.fzf_exec(items, {
    prompt = prompt or "Blocks> ",
    cwd = notes.dir,
    previewer = "builtin",
    actions = { ["default"] = open_action },
  })
end

local function blocks_with(field, name)
  notes.ensure()
  local out = {}
  for _, b in ipairs(notes.cache.blocks) do
    if b[field][name] then table.insert(out, b) end
  end
  return out
end

local function pick_name(pool, prompt, on_select)
  notes.ensure()
  local items = {}
  for n, c in pairs(pool) do table.insert(items, string.format("%s  (%d)", n, c)) end
  table.sort(items)
  fzf.fzf_exec(items, {
    prompt = prompt,
    actions = {
      ["default"] = function(sel)
        if not sel or #sel == 0 then return end
        local name = sel[1]:match("^(.-)%s%s%(") or sel[1]
        vim.defer_fn(function() on_select(name) end, 50) -- fixes trailing i in fzf menu press
      end,
    },
  })
end

function M.wikilinks()
  pick_name(notes.cache.links, "Link> ", function(name)
    show_blocks(blocks_with("link_refs", name), name .. " > ")
  end)
end

function M.tags()
  pick_name(notes.cache.tags, "Tag> ", function(name)
    show_blocks(blocks_with("tag_refs", name), "#" .. name .. " > ")
  end)
end

function M.blocks()
  notes.ensure()
  show_blocks(notes.cache.blocks, "All blocks> ")
end

function M.backlinks()
  local w = vim.fn.expand("<cWORD>")
  w = w:gsub("^%[%[", ""):gsub("%]%].*", ""):gsub("^#", "")
  if w == "" then vim.notify("No word under cursor", vim.log.levels.WARN); return end
  local seen, merged = {}, {}
  for _, list in ipairs({ blocks_with("link_refs", w), blocks_with("tag_refs", w) }) do
    for _, b in ipairs(list) do
      local k = b.relpath .. ":" .. b.start_line
      if not seen[k] then seen[k] = true; table.insert(merged, b) end
    end
  end
  show_blocks(merged, w .. " > ")
end

return M
