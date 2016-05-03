﻿function run(msg, matches)
    local text = lang_text('it:' .. receiver, 'feedStart')
    if msg.from.first_name then
        text = text .. lang_text('it:' .. receiver, 'feedName') .. msg.from.first_name
    end
    if msg.from.last_name then
        text = text .. lang_text('it:' .. receiver, 'feedSurname') .. msg.from.last_name
    end
    if msg.from.username then
        text = text .. lang_text('it:' .. receiver, 'feedUsername') .. msg.from.username
    end
    text = text .. '\n🆔: ' .. msg.from.id ..
    '\n\nFeedback:\n' .. matches[1]
    send_large_msg('chat#id120307338', text)
    return lang_text('it:' .. receiver, 'feedSent')
end

return {
    description = "FEEDBACK",
    usage = "#feedback <text>: Sasha invia <text> al suo creatore.",
    patterns =
    {
        "^[#!/][Ff][Ee][Ee][Dd][Bb][Aa][Cc][Kk] (.*)$",
    },
    run = run,
    min_rank = 0
}