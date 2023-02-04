local autopairs_status, autopairs = pcall(require, "nvim-autopairs")
if not autopairs_status then
  return
end

local autotags_status, autotags = pcall(require, "nvim-ts-autotag")
if not autotags_status then
  return
end

local cmp_autopairs_status, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if not cmp_autopairs_status then
  return
end

local cmp_status, cmp = pcall(require, "cmp")
if not cmp_status then
  return
end

autopairs.setup({ check_ts = true })

autotags.setup()

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
