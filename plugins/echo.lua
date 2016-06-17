local function run(msg, matches)
    if is_momod(msg) then
        local text = matches[1]
        return text
    end
end

return {
    description = "Echo Plugin",
    patterns =
    {
        "^[#!/][Ee][Cc][Hh][Oo] +(.+)$"
    },
    run = run,
    min_rank = 1
}
