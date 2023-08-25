local key = KEYS[1]
local val = redis.call("get", key)
if (not val) then
  redis.call("set", key, ARGV[1], "exat", ARGV[2])
  local sum = tonumber(redis.call("incrby", key .. ':sum', ARGV[1]))
  local cnt = tonumber(redis.call("incr", key .. ':cnt'))
  return { tonumber(ARGV[1]), sum / cnt }
end
return { tonumber(val), tonumber(redis.call("get", key .. ':sum')) / tonumber(redis.call("get", key .. ':cnt')) }
