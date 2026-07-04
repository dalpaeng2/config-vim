-- Workaround for neotest-ruby-minitest (volodya-lombrozo/neotest-ruby-minitest)
-- showing passing Rails-style `test "description" do ... end` tests as failed.
--
-- Root cause: the plugin's rails_query captures the raw DSL description string
-- (e.g. "plain visit") as the test position's name, but Rails'
-- ActiveSupport::TestCase.test(name, &block) macro actually defines the method
-- as "test_" + name.gsub(/\s+/, "_") (e.g. "test_plain_visit"). The plugin's
-- Ruby-side JSON reporter (ruby/json_tap.rb) reports that real method name, so
-- the tree position id and the result id never match, and neotest's core
-- fallback (client/runner.lua) marks the unmatched tree position as "failed".
--
-- This module duplicates positions.lua's discover_positions logic (queries
-- copied verbatim from the installed plugin) but adds a `build_position` that
-- normalizes DSL-captured test names to match Rails' real method name before
-- the tree/position ids are computed. It is monkey-patched onto the plugin's
-- already-`require`d module table from lua/plugins/neotest.lua.
--
-- If the upstream plugin changes its queries, resync bare_query/plain_query/
-- rails_query below from:
-- ~/.local/share/nvim/lazy/neotest-ruby-minitest/lua/neotest-ruby-minitest/positions.lua

local lib = require("neotest.lib")

local M = {}

---@param file_path string
---@param source string
---@param captured_nodes table<string, userdata>
---@param metadata table
M._build_position = function(file_path, source, captured_nodes, metadata)
  local match_type
  if captured_nodes["test.name"] then
    match_type = "test"
  elseif captured_nodes["namespace.name"] then
    match_type = "namespace"
  end
  if not match_type then
    return
  end

  local name = vim.treesitter.get_node_text(captured_nodes[match_type .. ".name"], source)
  if match_type == "test" and not name:match("^test_") then
    -- Mirror ActiveSupport::TestCase.test's method-name mangling.
    name = "test_" .. name:gsub("%s+", "_")
  end
  local definition = captured_nodes[match_type .. ".definition"]

  return {
    type = match_type,
    path = file_path,
    name = name,
    range = { definition:range() },
  }
end

local function parse_positions(file, query)
  return lib.treesitter.parse_positions(file, query, {
    nested_tests = true,
    require_namespaces = true,
    position_id = "",
    build_position = 'require("config.neotest_ruby_minitest_railsfix")._build_position',
  })
end

local plain_query = [[
    (
      class
      name: (constant) @namespace.name
      (superclass (scope_resolution) @superclass (#match? @superclass "Test$"))
    ) @namespace.definition
    (
      method
      name: (identifier) @test.name (#match? @test.name "^test_")
    ) @test.definition
]]

local function plain(file)
  return parse_positions(file, plain_query)
end

local bare_query = [[
    (
     class
     name: (constant) @namespace.name
     (superclass
      [
        (scope_resolution) @superclass.fq
        (constant)         @superclass.name
      ]
     )
  ) @namespace.definition

  (
    method
    name: (identifier) @test.name (#match? @test.name "^test_")
  ) @test.definition
]]

local function bare(file)
  return parse_positions(file, bare_query)
end

local rails_query = [[
(class
  name: (constant) @namespace.name
  (superclass
    (scope_resolution
      name: (constant) @superclass.name (#any-of? @superclass.name "SystemTestCase" "TestCase" "IntegrationTest"))
    )
  ) @namespace.definition

(class
  name: (constant) @namespace.name
  (superclass
    (constant) @superclass.name (#match? @superclass.name "Test")
    )
  ) @namespace.definition

(class
  name: (scope_resolution) @namespace.name
  (superclass
    (constant) @superclass.name (#match? @superclass.name "Test")
    )
  ) @namespace.definition

(class
  name: (scope_resolution) @namespace.name
  (superclass
    (scope_resolution
      name: (constant) @superclass.name (#any-of? @superclass.name "SystemTestCase" "TestCase" "IntegrationTest"))
    )
  ) @namespace.definition

(call
  method: (identifier) @fname (#match? @fname "test")
  arguments: (argument_list
               (string ( string_content ) @test.name))
  ) @test.definition
]]

local function rails(file)
  return parse_positions(file, rails_query)
end

local function count_nodes(tree)
  local function recurse(node)
    local n = 1
    if not node then
      return n
    end
    for _, child in ipairs(node:children()) do
      n = n + recurse(child)
    end
    return n
  end
  return recurse(tree)
end

---@param file_path string
---@return neotest.Tree
M.discover_positions = function(file_path)
  if not vim.loop.fs_stat(file_path) then
    error("file does not exist: " .. file_path)
  end
  local nodes = {
    bare(file_path),
    plain(file_path),
    rails(file_path),
  }
  local best
  local nbest = -1
  for _, value in ipairs(nodes) do
    local cnodes = count_nodes(value)
    if nbest < cnodes then
      nbest = cnodes
      best = value
    end
  end
  return best
end

return M
