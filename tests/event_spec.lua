-- SinkOrSwim Event lib tests
package.path = package.path .. ";../?.lua"

local Event = require('src/event')

describe("Event Library Tests", function()
  
  describe("Basic Functionality", function()
    it("Event module loaded correctly", function()
      assert.is_not_true(Event == nil)
      assert.True(type(Event) == "table")
      assert.True(type(Event.on) == "function")
    end)

    it("Basic Event Registers", function()
      local event_name = "dummyEvent"
      local event_str = "fail"
      Event.on(event_name, function ()
        event_str = "pass"
      end)

      assert.True(Event.subscribers[event_name] ~= nil)
      
      Event.send(event_name)

      assert.are.equal("pass", event_str)

    end)

    it("Multiple Events Trigger under same name", function()
      Event.clearAll()

      local a_was_called = false
      local b_was_called = false

      Event.on("trigger", function()
        a_was_called = true
      end)

      Event.on("trigger", function()
        b_was_called = true
      end)

      Event.send("trigger")

      assert.True(Event.count() == 2)
      assert.True(a_was_called, b_was_called)
    end)
  end)
end)
