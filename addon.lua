local myname, ns = ...

-- TODO: I *could* make it identical to stock via atlas markup with Coin-Gold, Coin-Silver, Coin-Copper

local function copper_to_pretty_money(c)
    if c >= 10000 then
        return ("|cffffffff%d|r|cffffd700%s|r |cffffffff%d|r|cffc7c7cf%s|r |cffffffff%d|r|cffeda55f%s|r"):format(
            BreakUpLargeNumbers(c/10000), GOLD_AMOUNT_SYMBOL, (c/100)%100, SILVER_AMOUNT_SYMBOL, c%100, COPPER_AMOUNT_SYMBOL
        )
    elseif c >= 100 then
        return ("|cffffffff%d|r|cffc7c7cf%s|r |cffffffff%d|r|cffeda55f%s|r"):format((c/100)%100, SILVER_AMOUNT_SYMBOL, c%100, COPPER_AMOUNT_SYMBOL)
    else
        return ("|cffffffff%d|r|cffeda55f%s|r"):format(c%100, COPPER_AMOUNT_SYMBOL)
    end
end
local function cleanTooltipMoney(tooltip, lineData)
    -- see: TooltipDataRules.SellPrice and GameTooltip_OnTooltipAddMoney
    if lineData.type == Enum.TooltipDataLineType.SellPrice and lineData.price then
        if lineData.maxPrice and lineData.maxPrice >= 1 then
            GameTooltip_AddColoredLine(tooltip, ("%s:"):format(SELL_PRICE), HIGHLIGHT_FONT_COLOR)
            local indent = string.rep(" ", 4)
            GameTooltip_AddHighlightLine(tooltip, string.format("%s%s", MINIMUM, copper_to_pretty_money(lineData.price)))
            GameTooltip_AddHighlightLine(tooltip, string.format("%s%s", MAXIMUM, copper_to_pretty_money(lineData.maxPrice)))
        else
            GameTooltip_AddHighlightLine(tooltip, string.format("%s: %s", SELL_PRICE, copper_to_pretty_money(lineData.price)))
        end
        return true
    end
end

EventUtil.ContinueOnAddOnLoaded(myname, function()
    TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.SellPrice, cleanTooltipMoney)
end)
