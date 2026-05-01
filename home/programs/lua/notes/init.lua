local M = {}

local NOTES_DIR = vim.fn.expand("~/notes")
M.dir = NOTES_DIR

local cache = { links = {}, tags = {}, blocks = {}, dirty = true }
M.cache = cache

local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

-- Header: line starts with [[NAME]], optionally followed by anything else.
local function parse_header(line)
  return trim(line):match("^%[%[([^%]]+)%]%]")
end

local function extract_refs(line, link_refs, tag_refs)
  for name in line:gmatch("%[%[([^%]]+)%]%]") do
    link_refs[name] = true
  end
  local i = 1
  while i <= #line do
    local s, e, tag = line:find("#([%w_/%-]+)", i)
    if not s then break end
    local before = (s == 1) or line:sub(s - 1, s - 1):match("%s")
    -- Skip ATX headings: '#' at line start followed by space won't match anyway,
    -- but also reject when s==1 and the next non-word context suggests a heading.
    if before then tag_refs[tag] = true end
    i = e + 1
  end
end

local function read_lines(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local lines = {}
  for l in f:lines() do table.insert(lines, l) end
  f:close()
  return lines
end

local function emit(block)
  local snippet = ""
  for _, l in ipairs(block.content_lines or {}) do
    local t = trim(l)
    if t ~= "" then snippet = t; break end
  end
  block.snippet = snippet
  table.insert(cache.blocks, block)
  for n in pairs(block.link_refs) do cache.links[n] = (cache.links[n] or 0) + 1 end
  for n in pairs(block.tag_refs)  do cache.tags[n]  = (cache.tags[n]  or 0) + 1 end
end

local function process_journal(path, relpath)
  local lines = read_lines(path); if not lines then return end

  local current = {
    header = "(preamble)", start_line = 1, content_lines = {},
    link_refs = {}, tag_refs = {}, is_preamble = true,
    relpath = relpath, path = path,
  }

  local function close_block(end_line)
    current.end_line = end_line
    if current.is_preamble then
      local has = false
      for _, l in ipairs(current.content_lines) do
        if trim(l) ~= "" then has = true; break end
      end
      if not has then return end
    end
    emit(current)
  end

  for lnum, line in ipairs(lines) do
    local header = parse_header(line)
    if header then
      close_block(lnum - 1)
      current = {
        header = header, start_line = lnum, content_lines = {},
        link_refs = { [header] = true }, tag_refs = {},
        is_preamble = false, relpath = relpath, path = path,
      }
      extract_refs(line, current.link_refs, current.tag_refs)
    else
      table.insert(current.content_lines, line)
      extract_refs(line, current.link_refs, current.tag_refs)
    end
  end
  close_block(#lines)
end

local function process_page(path, relpath)
  local lines = read_lines(path); if not lines then return end
  local header = relpath:gsub("%.md$", ""):gsub("^pages/", "")
  local block = {
    header = header, start_line = 1, end_line = #lines,
    content_lines = lines, link_refs = { [header] = true }, tag_refs = {},
    relpath = relpath, path = path, is_page = true,
  }
  for _, l in ipairs(lines) do extract_refs(l, block.link_refs, block.tag_refs) end
  emit(block)
end

function M.rebuild()
  for k in pairs(cache.links)  do cache.links[k]  = nil end
  for k in pairs(cache.tags)   do cache.tags[k]   = nil end
  for k in pairs(cache.blocks) do cache.blocks[k] = nil end
  local files = vim.fs.find(
    function(name) return name:match("%.md$") end,
    { path = NOTES_DIR, type = "file", limit = math.huge }
  )
  for _, path in ipairs(files) do
    local rel = path:sub(#NOTES_DIR + 2)
    if rel:match("^journals/") then process_journal(path, rel)
    else process_page(path, rel) end
  end
  cache.dirty = false
end

function M.ensure() if cache.dirty then M.rebuild() end end

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = NOTES_DIR .. "/**/*.md",
  callback = function() cache.dirty = true end,
})

vim.api.nvim_create_user_command("Journal", function()
  vim.fn.mkdir(NOTES_DIR .. "/journals", "p")
  vim.cmd("edit " .. vim.fn.fnameescape(
    NOTES_DIR .. "/journals/" .. os.date("%Y_%m_%d") .. ".md"))
end, {})

return M
