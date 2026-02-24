local myname, ns = ...

local db

local X = 10
local GOLD_ATLAS = CreateAtlasMarkup("Coin-Gold", X, X, 3)
local SILVER_ATLAS = CreateAtlasMarkup("Coin-Silver", X, X, 3)
local COPPER_ATLAS = CreateAtlasMarkup("Coin-Copper", X, X, 3)

local function copperToPrettyMoney(c, coins)
    local G, S, C
    if coins then
        G, S, C = GOLD_ATLAS, SILVER_ATLAS, COPPER_ATLAS
    else
        G, S, C = GOLD_AMOUNT_SYMBOL, SILVER_AMOUNT_SYMBOL, COPPER_AMOUNT_SYMBOL
    end

    if c >= 10000 then
        return ("|cffffffff%d|r|cffffd700%s|r |cffffffff%d|r|cffc7c7cf%s|r |cffffffff%d|r|cffeda55f%s|r"):format(
            BreakUpLargeNumbers(c/10000), G, (c/100)%100, S, c%100, C
        )
    elseif c >= 100 then
        return ("|cffffffff%d|r|cffc7c7cf%s|r |cffffffff%d|r|cffeda55f%s|r"):format((c/100)%100, S, c%100, C)
    else
        return ("|cffffffff%d|r|cffeda55f%s|r"):format(c%100, C)
    end
end
local function cleanTooltipMoney(tooltip, lineData)
    -- see: TooltipDataRules.SellPrice and GameTooltip_OnTooltipAddMoney
    if lineData.type == Enum.TooltipDataLineType.SellPrice and lineData.price then
        if lineData.maxPrice and lineData.maxPrice >= 1 then
            GameTooltip_AddColoredLine(tooltip, ("%s:"):format(SELL_PRICE), HIGHLIGHT_FONT_COLOR)
            local indent = string.rep(" ", 4)
            GameTooltip_AddHighlightLine(tooltip, string.format("%s%s", MINIMUM, copperToPrettyMoney(lineData.price, db.coins)))
            GameTooltip_AddHighlightLine(tooltip, string.format("%s%s", MAXIMUM, copperToPrettyMoney(lineData.maxPrice, db.coins)))
        else
            GameTooltip_AddHighlightLine(tooltip, string.format("%s: %s", SELL_PRICE, copperToPrettyMoney(lineData.price, db.coins)))
        end
        return true
    end
end

EventUtil.ContinueOnAddOnLoaded(myname, function()
    local dbname = myname.."DB"
    _G[dbname] = _G[dbname] or {}
    db = _G[dbname]
    ns.db = db

    TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.SellPrice, cleanTooltipMoney)
end)

do
    local slash = "/"..myname:lower()
    _G["SLASH_".. myname:upper().."1"] = slash
    local function P(...) print("|cFF33FF99".. myname .. "|r:", ...) end
    SlashCmdList[myname:upper()] = function(msg)
        msg = msg:trim()
        if msg == "" then
            P("make tooltip money cleaner")
            P("-", slash, "coins:", db.coins and "classic" or "simple")
        elseif msg == "coins" then
            db.coins = not db.coins
            P("coins are now", db.coins and "classic" or "simple")
        end
    end
end
