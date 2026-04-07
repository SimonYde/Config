---@diagnostic disable-next-line: lowercase-global
function setup(config)
    config.ui = {
        colors = {
            dimmed = { fg = 'white' },
        },
    }

    config.action('diff-delta', function()
        local change_id = context.change_id()

        if change_id then
            exec_shell(
                string.format('jj show -r %q --summary --git --color=always | delta --pager "less -R"', change_id)
            )
        end
    end, {
        key = 'x',
        scope = 'revisions',
        desc = 'diff change with delta',
    })
end
