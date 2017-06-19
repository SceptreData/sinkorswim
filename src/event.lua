local Event = {}

Event.subscribers = {}

local num_subs  = 0

local function setSub(sub)
  Event.subscribers[sub.name] = sub
end


local function getSub(name)
  return Event.subscribers[name]
end


local function subscribe(name, cb)
  local sub = {
      name = name,
      cb   = cb,
      next = getSub(name),
      remove = remove
  }

  if sub.next then
      sub.next.prev = sub
  end

  setSub(sub)
  num_subs = num_subs + 1
  return sub
end


local function remove(sub)
    if sub.prev then
        sub.prev.next = sub.next
    end

    if sub.next then
        sub.next.prev = sub.prev
    end

    local head = getSub(sub.name)
    if head == sub then
        setSub(sub.next)
    end

    sub.next = nil
    sub.prev = nil

    num_subs = num_subs - 1

    return sub
end


function Event.on(name, cb)
  subscribe(name, cb)
end


-- I pass the Subscriber to the event callback, so the event can remove
-- the subscription if it chooses.
function Event.send(name, ...)
  local sub = getSub(name)
  while sub do
    if sub.cb(sub, ...) == false then
      return sub
    end
    sub = sub.next
  end
end


function Event.count()
  return num_subs
end


function Event.countUnique()
  local n = 0
  for _, _ in pairs(Event.subscribers) do
    n = n + 1
  end
  return n
end

function Event.clearAll()
  Event.subscribers = {}
  num_subs = 0
end

return Event
