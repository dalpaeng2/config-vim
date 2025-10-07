-- ~/.config/nvim/lua/tabs.lua
-- 전역(기본) 값: 4칸, 스페이스 기반 들여쓰기
local o = vim.opt
o.tabstop = 2        -- 실제 \t의 표시 폭
o.softtabstop = 2    -- Tab/Backspace가 움직이는 칸
o.shiftwidth = 2     -- 자동 들여쓰기 폭(>>, <<, =)
o.expandtab = true   -- Tab 입력 시 스페이스로
o.smarttab = true
o.autoindent = true
o.smartindent = true
o.shiftround = true
o.copyindent = true          -- 기존 라인의 탭/스페이스 패턴을 복사
o.preserveindent = true      -- 기존 들여쓰기 스타일 최대한 유지

-- 가독성을 위한 특수문자 표시 (원하면 끄세요)
o.list = true
o.listchars = { tab = "»·", trail = "·", extends = "⟩", precedes = "⟨" }

-- 파일타입별 들여쓰기 헬퍼
local function set_indent(ts, sw, expand)
  local lo = vim.opt_local
  lo.tabstop = ts
  lo.softtabstop = ts
  lo.shiftwidth = sw or ts
  lo.expandtab = expand
end

-- 2칸 스페이스: 웹 프론트엔드 계열
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "javascript","typescript","javascriptreact","typescriptreact",
    "json","css","scss","html","markdown","vue","svelte","yaml","toml"
  },
  callback = function() set_indent(2, 2, true) end,
})

-- 4칸 스페이스: Python/백엔드/스크립트 계열
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python","lua","ruby","rust","c","cpp","java","sh","zsh" },
  callback = function() set_indent(4, 4, true) end,
})

-- 탭 기반: Go, Makefile (표시 폭은 8이 표준)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go" },
  callback = function()
    -- gofmt는 탭을 사용. softtabstop=0이면 <Tab>이 항상 실제 \t로 들어감
    local lo = vim.opt_local
    lo.tabstop = 2
    lo.softtabstop = 0
    lo.shiftwidth = 2
    lo.expandtab = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "make" },
  callback = function()
    local lo = vim.opt_local
    lo.tabstop = 8
    lo.softtabstop = 0
    lo.shiftwidth = 8
    lo.expandtab = false -- Makefile은 탭 필수
  end,
})
