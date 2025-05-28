#!/usr/bin/env lua
--
-- File Name: layout.lua
-- Description: River layout; moddifed verion of the Recreation of the rivertile layout orignally made by KMIJPH
-- License: GPLv3+
-- Creation Date: 01 Feb 2023 09:23:46

-- globals
local main_count = 1
local main_ratio = 0.50
local outer_gap = 4
local inner_gap = 5
local borderSize = 3 
local curBorderSize = 3
local smart_gaps = false
local location_horizontal = "left"
local location_vertical = "top"
local monitorData = {}
local pertag = true
local pertagLayouts = true
local barHeight = 30
local barActive = true
-- local count = 0

--- Layout generator
--@param args: table{width, height, count, tags}
function handle_layout(args)
    local layout = {}

    -- local args.output = args.output

    -- currentLayout = monitorLayouts[args.output] or 'normalTile'
    if monitorData[args.output] == nil then
        monitorData[args.output] = {layout='normalTile',main_ratio=0.50,main_count=1,scroll=0}
    end

    local currentLayout 

    local main_ratio 
    local main_count 
    if pertag then
        if monitorData[args.output][args.tags] == nil then
            monitorData[args.output][args.tags] = {main_ratio=0.50,main_count=1,layout='normalTile'}
        end
        if args.count < monitorData[args.output][args.tags].main_count then
            monitorData[args.output][args.tags].main_count = args.count
        end
        main_ratio = monitorData[args.output][args.tags].main_ratio
        main_count = monitorData[args.output][args.tags].main_count
    else
        main_ratio = monitorData[args.output].main_ratio
        main_count = monitorData[args.output].main_count
    end

    if pertagLayouts then
        currentLayout = monitorData[args.output][args.tags].layout
    else
        currentLayout = monitorData[args.output].layout
    end


    local scroll = monitorData[args.output].scroll
    -- local main_ratio 
    local count = args.count
    -- if count < main_count then
    --     monitorData[args.output].main_count = count
    --     main_count = count
    -- end

    local layouts = { normalTile=function()
        local outer_gap = outer_gap
        local inner_gap = inner_gap
        -- local main_count = main_count
        if count < main_count then
            main_count = count
        end
        if count < 2 and smart_gaps == true then
                outer_gap = 0
                inner_gap = 0
            -- end
            -- if smart_border == true then
            --     setBorder(0)
            -- end
        -- elseif smart_border == true then
        --         setBorder(borderSize)
        end
        local secondary_count = args.count - main_count
        local usable_width, usable_height
        local location
    
        -- check whether monitor is vertical or horizontal
        if args.width > args.height then
            location = location_horizontal
        else
            location = location_vertical
        end
    
        if location == "left" or location == "right" then
            usable_width = args.width - (2 * outer_gap)
            usable_height = args.height - (2 * outer_gap)
        else
            usable_width = args.height - (2 * outer_gap)
            usable_height = args.width - (2 * outer_gap)
        end
    
        local main_width, main_height, main_height_rem
        local secondary_width, secondary_heigth, secondary_height_rem
    
        -- layout creation
        if main_count > 0 and secondary_count > 0 then
            main_width = main_ratio * usable_width
            main_height = usable_height / main_count
            main_height_rem = math.fmod(usable_height, main_count)
            secondary_width = usable_width - main_width
            secondary_heigth = usable_height / secondary_count
            secondary_height_rem = math.fmod(usable_height, secondary_count)
        elseif main_count > 0 then
            main_width = usable_width
            main_height = usable_height / main_count
            main_height_rem = math.fmod(usable_height, main_count)
        elseif secondary_width > 0 then
            main_width = 0
            secondary_width = usable_width
            secondary_heigth = usable_height / secondary_count
            secondary_height_rem = math.fmod(usable_height, secondary_count)
        end
    
        -- set x, y, w, h
        for i = 0, (args.count - 1) do
            local x, y, width, height
    
            if i < main_count then
                x = 0
                y = (i * main_height) + (i > 0 and { main_height_rem } or { 0 })[1]
                width = main_width
                height = main_height + (i == 0 and { main_height_rem } or { 0 })[1]
            else
                x = main_width
                y = (i - main_count) * secondary_heigth + (i > main_count and { secondary_height_rem } or { 0 })[1]
                width = secondary_width
                height = secondary_heigth + (i == main_count and { secondary_height_rem } or { 0 })[1]
            end
    
            x = x + inner_gap
            y = y + inner_gap
            width = width - (2 * inner_gap)
            height = height - (2 * inner_gap)
    
            -- set depending on location
            if location == "left" then
                table.insert(layout, {
                    x + outer_gap,
                    y + outer_gap,
                    width,
                    height,
                })
            elseif location == "right" then
                table.insert(layout, {
                    usable_width - width - x + outer_gap,
                    y + outer_gap,
                    width,
                    height,
                })
            elseif location == "top" then
                table.insert(layout, {
                    y + outer_gap,
                    x + outer_gap,
                    height,
                    width,
                })
            else
                table.insert(layout, {
                    y + outer_gap,
                    usable_width - width - x + outer_gap,
                    height,
                    width,
                })
            end
        end
    end,
    monoclefull = function()
        -- setBorder(0)
        local barHeight = barHeight
        if barActive == false then
            barHeight = 0
        end
        for i = 1,count do
            table.insert(layout,{0-curBorderSize,0-(curBorderSize+barHeight),args.width+(curBorderSize*2),args.height+(curBorderSize*2+barHeight)})
        end
    end,
    monocle = function()
        for i = 1,count do
            table.insert(layout,{0,0,args.width,args.height})
        end
    end,
    monocleGaps = function()
        for i = 1,count do
            local gap = outer_gap + inner_gap
            table.insert(layout,{gap,gap,args.width-gap*2,args.height-gap*2})
        end
    end,
    paperwm = function() -- really silly because I had never used a scrolling wm when i made this layout lmao so its quite funcy
        local winCount = math.min(main_count,count)
        local width = args.width/winCount
        local x,y = width*scroll*-1,0
        for i = 1,count do
            table.insert(layout,{x,y,width,args.height})
            x = x + width
            -- y = y + args.height
        end
    end
    
    }
    layouts[currentLayout]()
    return layout
end
function onload()
    -- print(os.execute('pgrep waybar'))
    if os.execute('pgrep waybar') == 0 then
        barActive = true
        os.execute("killall -SIGUSR2 waybar")
    else
        barActive = false
    end
end

function toggleBorderWidth()
    if curBorderSize == borderSize then
        curBorderSize = 0
    else
        curBorderSize = borderSize
    end
    setBorder(curBorderSize)
end
function toggleWaybar()
    if barActive == false then
        -- this signal resets the bar
        os.execute("killall -SIGUSR2 waybar")
    elseif barActive == true then
        -- this signal hides the bar
        os.execute("killall -SIGUSR1 waybar")
    end
    barActive = not barActive
end


function switchLayout(newLayout)
    if barActive == true then
        if os.execute('pgrep waybar') ~= 0 then
            barActive = false
        end
    end
    if newLayout == "monocle" then
        -- setBorder(0)
    else
        setBorder(borderSize)
    end
    -- os.execute('notify-send targetOuput:' .. targetOutput .. " args.output:" .. thisOutput)
    -- monitorLayouts[targetOutput] = newLayout

    if pertagLayouts then
        monitorData[CMD_OUTPUT][CMD_TAGS].layout = newLayout
    else
        monitorData[CMD_OUTPUT].layout = newLayout
    end
end

function flip()
    for _ = 0, count do
        os.execute("riverctl swap next")
    end
    os.execute("riverctl focus-view previous")
end

function setBorder(num)
    os.execute("riverctl border-width "..num)
end

--- Increases main ratio
-- Run with `riverctl send-layout-cmd luatile "increase_main()"`
function increase_main()
    -- if main_ratio < 0.9 then
    if monitorData[CMD_OUTPUT].layout == "paperwm" then
        monitorData[CMD_OUTPUT].scroll = monitorData[CMD_OUTPUT].scroll + 0.01
    elseif monitorData[CMD_OUTPUT].main_ratio < 0.9 then
        if pertag == true then
            monitorData[CMD_OUTPUT][CMD_TAGS].main_ratio = monitorData[CMD_OUTPUT][CMD_TAGS].main_ratio + 0.05
        else
            monitorData[CMD_OUTPUT].main_ratio = monitorData[CMD_OUTPUT].main_ratio + 0.05
        end
        -- main_ratio = main_ratio + 0.05
    end
end

--- Decreases main ratio
-- Run with `riverctl send-layout-cmd luatile "decrease_main()"`
function decrease_main()
    if monitorData[CMD_OUTPUT].layout == "paperwm" then
        monitorData[CMD_OUTPUT].scroll = math.max(monitorData[CMD_OUTPUT].scroll - 0.01,0)
    elseif monitorData[CMD_OUTPUT].main_ratio > 0.1 then
        if pertag == true then
            monitorData[CMD_OUTPUT][CMD_TAGS].main_ratio = monitorData[CMD_OUTPUT][CMD_TAGS].main_ratio - 0.05
        else
            monitorData[CMD_OUTPUT].main_ratio = monitorData[CMD_OUTPUT].main_ratio - 0.05
        end
        -- main_ratio = main_ratio - 0.05
    end
end

--- Increases main count
-- Run with `riverctl send-layout-cmd luatile "increase_count()"`
function increase_count()
    -- main_count = main_count + 1
    if pertag == true then
        -- if monitorData[CMD_OUTPUT][CMD_TAGS].main_count <= 
        monitorData[CMD_OUTPUT][CMD_TAGS].main_count = monitorData[CMD_OUTPUT][CMD_TAGS].main_count + 1
    else
        monitorData[CMD_OUTPUT].main_count = monitorData[CMD_OUTPUT].main_count + 1
    end
end

--- Decreases main count
-- Run with `riverctl send-layout-cmd luatile "decrease_count()"`
function decrease_count()
    -- if main_count >= 2 then
    if pertag == true then
        if monitorData[CMD_OUTPUT][CMD_TAGS].main_count >= 2 then
            monitorData[CMD_OUTPUT][CMD_TAGS].main_count = monitorData[CMD_OUTPUT][CMD_TAGS].main_count - 1
        end
    else
        if monitorData[CMD_OUTPUT].main_count >= 2 then
            -- main_count = main_count - 1
            monitorData[CMD_OUTPUT].main_count = monitorData[CMD_OUTPUT].main_count - 1
        end
    end
end
