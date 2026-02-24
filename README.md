# MoneyLaundering

This addon takes the sell price lines in all tooltips and turns them into a cleaner display, using either letters or inline symbols.

A side-effect of this is that it removes calls to `GameTooltip_OnTooltipAddMoney` from normal Blizzard item tooltips. This should probably help with the error `MoneyFrame.lua:307: attempt to perform arithmetic on a secret number value`.

It's probably also pretty good for color-blindness!

## Usage

Just install it.

There's one command:

`/moneylaundering coins` - toggle the display mode between letters and symbols
