local lazy = require("syde.lazy")

lazy.lazy_load(function ()
    local todo_comments = vim.F.npcall(require, "todo-comments")
    if todo_comments then
        todo_comments.setup {}
    end
end)
