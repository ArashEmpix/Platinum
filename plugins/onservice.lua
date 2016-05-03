﻿-- Will leave the group if be added
local function run(msg, matches)
    local bot_id = our_id
    local receiver = get_receiver(msg)
    if (matches[1]:lower() == 'leave' or matches[1]:lower() == 'sasha abbandona') and is_admin1(msg) then
        chat_del_user("chat#id" .. msg.to.id, 'user#id' .. bot_id, ok_cb, false)
        leave_channel(receiver, ok_cb, false)
    elseif msg.service and msg.action.type == "chat_add_user" and msg.action.user.id == tonumber(bot_id) and not is_admin1(msg) then
        send_large_msg(receiver, lang_text('it:' .. 'notMyGroup'), ok_cb, false)
        chat_del_user(receiver, 'user#id' .. bot_id, ok_cb, false)
        leave_channel(receiver, ok_cb, false)
    end
end

return {
    description = "ONSERVICE",
    usage =
    {
        "ADMIN",
        "(#leave|sasha abbandona): Sasha lascia il gruppo.",
    },
    patterns =
    {
        "^[#!/]([Ll][Ee][Aa][Vv][Ee])$",
        "^([Ss][Aa][Ss][Hh][Aa] [Aa][Bb][Bb][Aa][Nn][Dd][Oo][Nn][Aa])$",
        "^!!tgservice (.+)$",
    },
    run = run,
    min_rank = 4
}