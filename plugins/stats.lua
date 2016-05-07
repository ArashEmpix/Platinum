﻿-- Returns a table with `name` and `msgs`
local function get_msgs_user_chat(user_id, chat_id)
    local user_info = { }
    local uhash = 'user:' .. user_id
    local user = redis:hgetall(uhash)
    local um_hash = 'msgs:' .. user_id .. ':' .. chat_id
    user_info.msgs = tonumber(redis:get(um_hash) or 0)
    user_info.name = user_print_name(user) .. ' [' .. user_id .. ']'
    return user_info
end

local function chat_stats(chat_id)
    -- Users on chat
    local hash = 'chat:' .. chat_id .. ':users'
    local users = redis:smembers(hash)
    local users_info = { }
    -- Get user info
    for i = 1, #users do
        local user_id = users[i]
        local user_info = get_msgs_user_chat(user_id, chat_id)
        table.insert(users_info, user_info)
    end
    -- Sort users by msgs number
    table.sort(users_info, function(a, b)
        if a.msgs and b.msgs then
            return a.msgs > b.msgs
        end
    end )
    local text = lang_text('usersInChat')
    for k, user in pairs(users_info) do
        text = text .. user.name .. ' = ' .. user.msgs .. '\n'
    end
    local file = io.open("./groups/lists/" .. chat_id .. "stats.txt", "w")
    file:write(text)
    file:flush()
    file:close()
    return
    -- text
end

local function chat_stats2(chat_id)
    -- Users on chat
    local hash = 'chat:' .. chat_id .. ':users'
    local users = redis:smembers(hash)
    local users_info = { }

    -- Get user info
    for i = 1, #users do
        local user_id = users[i]
        local user_info = get_msgs_user_chat(user_id, chat_id)
        table.insert(users_info, user_info)
    end

    -- Sort users by msgs number
    table.sort(users_info, function(a, b)
        if a.msgs and b.msgs then
            return a.msgs > b.msgs
        end
    end )

    local text = lang_text('usersInChat')
    for k, user in pairs(users_info) do
        text = text .. user.name .. ' = ' .. user.msgs .. '\n'
    end
    return text
end

local function channel_stats(chat_id)
    -- Users on chat
    local hash = 'channel:' .. chat_id .. ':users'
    local users = redis:smembers(hash)
    local users_info = { }
    -- Get user info
    for i = 1, #users do
        local user_id = users[i]
        local user_info = get_msgs_user_chat(user_id, chat_id)
        table.insert(users_info, user_info)
    end
    -- Sort users by msgs number
    table.sort(users_info, function(a, b)
        if a.msgs and b.msgs then
            return a.msgs > b.msgs
        end
    end )
    local text = lang_text('usersInChat')
    for k, user in pairs(users_info) do
        text = text .. user.name .. ' = ' .. user.msgs .. '\n'
    end
    local file = io.open("./groups/lists/" .. chat_id .. "stats.txt", "w")
    file:write(text)
    file:flush()
    file:close()
    return
    -- text
end

local function channel_stats2(chat_id)
    -- Users on chat
    local hash = 'channel:' .. chat_id .. ':users'
    local users = redis:smembers(hash)
    local users_info = { }

    -- Get user info
    for i = 1, #users do
        local user_id = users[i]
        local user_info = get_msgs_user_chat(user_id, chat_id)
        table.insert(users_info, user_info)
    end

    -- Sort users by msgs number
    table.sort(users_info, function(a, b)
        if a.msgs and b.msgs then
            return a.msgs > b.msgs
        end
    end )

    local text = lang_text('usersInChat')
    for k, user in pairs(users_info) do
        text = text .. user.name .. ' = ' .. user.msgs .. '\n'
    end
    return text
end

local function bot_stats()

    local redis_scan = "local cursor = '0'\n" ..
    "local count = 0\n" ..
    "repeat\n" ..
    "local r = redis.call(\"SCAN\", cursor, \"MATCH\", KEYS[1])\n" ..
    "cursor = r[1]\n" ..
    "count = count + #r[2]\n" ..
    "until cursor == '0'\n" ..
    "return count\n"

    -- Users
    local hash = 'msgs:*:' .. our_id
    local r = redis:eval(redis_scan, 1, hash)
    local text = lang_text('users') .. r

    hash = 'chat:*:users'
    r = redis:eval(redis_scan, 1, hash)
    text = text .. lang_text('groups') .. r
    return text
end

local function run(msg, matches)
    if matches[1]:lower() == 'aisasha' then
        -- Put everything you like :)
        local about = _config.about_text
        local name = user_print_name(msg.from)
        savelog(msg.to.id, name .. " [" .. msg.from.id .. "] used /aisasha ")
        return about
    end
    if matches[1]:lower() == "stats" or matches[1]:lower() == "messages" then
        if not matches[2] then
            if is_momod(msg) then
                if msg.to.type == 'chat' then
                    savelog(msg.to.id, user_print_name(msg.from) .. " [" .. msg.from.id .. "] requested group stats ")
                    send_large_msg(get_receiver(msg), chat_stats2(msg.to.id))
                elseif msg.to.type == 'channel' then
                    savelog(msg.to.id, user_print_name(msg.from) .. " [" .. msg.from.id .. "] requested supergroup stats ")
                    send_large_msg(get_receiver(msg), channel_stats2(msg.to.id))
                else
                    return
                end
            else
                return lang_text('require_mod')
            end
        elseif matches[2]:lower() == "aisasha" then
            if is_admin1(msg) then
                return bot_stats()
            else
                return lang_text('require_admin')
            end
        elseif matches[2]:lower() == "group" then
            if is_admin1(msg) then
                if msg.to.type == 'chat' then
                    send_large_msg(get_receiver(msg), chat_stats2(matches[3]))
                elseif msg.to.type == 'channel' then
                    send_large_msg(get_receiver(msg), channel_stats2(matches[3]))
                else
                    return
                end
            else
                return lang_text('require_admin')
            end
        end
        return
    elseif matches[1]:lower() == "statslist" or matches[1]:lower() == "messageslist" then
        if not matches[2] then
            if is_momod(msg) then
                if msg.to.type == 'chat' then
                    savelog(msg.to.id, user_print_name(msg.from) .. " [" .. msg.from.id .. "] requested group stats ")
                    chat_stats(msg.to.id)
                elseif msg.to.type == 'channel' then
                    savelog(msg.to.id, user_print_name(msg.from) .. " [" .. msg.from.id .. "] requested supergroup stats ")
                    channel_stats(msg.to.id)
                else
                    return
                end
                send_document(get_receiver(msg), "./groups/lists/" .. msg.to.id .. "stats.txt", ok_cb, false)
            else
                return lang_text('require_mod')
            end
        elseif matches[2]:lower() == "group" then
            if is_admin1(msg) then
                if msg.to.type == 'chat' then
                    chat_stats(matches[3])
                elseif msg.to.type == 'channel' then
                    channel_stats(matches[3])
                else
                    return
                end
                send_document(get_receiver(msg), "./groups/lists/" .. matches[3] .. "stats.txt", ok_cb, false)
            else
                return lang_text('require_admin')
            end
        end
        return
    end
end

return {
    description = "STATS",
    patterns =
    {
        "^[#!/]([Ss][Tt][Aa][Tt][Ss])$",
        "^[#!/]([Ss][Tt][Aa][Tt][Ss][Ll][Ii][Ss][Tt])$",
        "^[#!/]([Ss][Tt][Aa][Tt][Ss]) ([Gg][Rr][Oo][Uu][Pp]) (%d+)$",
        "^[#!/]([Ss][Tt][Aa][Tt][Ss][Ll][Ii][Ss][Tt]) ([Gg][Rr][Oo][Uu][Pp]) (%d+)$",
        "^[#!/]([Ss][Tt][Aa][Tt][Ss]) ([Aa][Ii][Ss][Aa][Ss][Hh][Aa])$",
        "^[#!/]?([Aa][Ii][Ss][Aa][Ss][Hh][Aa])$",
        -- stats
        "^[#!/]([Mm][Ee][Ss][Ss][Aa][Gg][Ee][Ss])$",
        -- statslist
        "^[#!/]([Mm][Ee][Ss][Ss][Aa][Gg][Ee][Ss][Ll][Ii][Ss][Tt])$",
    },
    run = run,
    min_rank = 0
    -- usage
    -- [#]aisasha
    -- MOD
    -- (#stats|#statslist|#messages)
    -- ADMIN
    -- (#stats|#statslist|#messages) group <group_id>
    -- (#stats|#statslist) aisasha
}