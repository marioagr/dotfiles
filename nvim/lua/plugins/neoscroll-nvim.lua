-- Add smooth scrolling to avoid jarring jumps.
return {
    "karb94/neoscroll.nvim",
    config = function()
        require('neoscroll').setup {}
    end
}
