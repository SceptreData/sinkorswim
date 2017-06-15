#!/usr/bin/env luajit

local plat = require('ffi').os

local LOVE
if plat == "Windows" then
  LOVE = 'lovec .'
else
  LOVE = 'love .'
end

-- Lint program info
local LINT  = 'luacheck -qq --std=luajit+love+busted .'
local LINT_FAIL_LVL   = 2

-- Test suite
local TEST_SUITE = 'busted tests/'

if os.execute(LINT) >= LINT_FAIL_LVL then
  print("\nLint check failed.")
  os.exit()
end
    
if os.execute(TEST_SUITE) > 0 then
    print("\nBusted fail!")
    os.exit()
end

-- Run program
os.execute(LOVE)
