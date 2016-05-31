local function run(msg, matches)
        if matches[1]:lower() == 'on' and is_sudo(msg) then
            enable_channel(get_receiver(msg), msg.to.id)
        end
        if matches[1]:lower() == 'off' and is_sudo(msg) then
            disable_channel(get_receiver(msg), msg.to.id)
        end
end

return {
    description = "BOT",
    patterns =
    {
        "^[#!/][Bb][Oo][Tt] ([Oo][Nn])",
        "^[#!/][Bb][Oo][Tt] ([Oo][Ff][Ff])"
    },
    run = run,
    pre_process = pre_process,
}
