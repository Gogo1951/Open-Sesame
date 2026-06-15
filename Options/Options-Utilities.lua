local ADDON_NAME, ns = ...

local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Options Helpers
--------------------------------------------------------------------------------

function ns.OptionsHeader(text, order)
    return {type = "header", name = GetColor("TITLE") .. text .. "|r", order = order}
end

function ns.OptionsDesc(text, order)
    return {type = "description", name = text, fontSize = "medium", order = order}
end

function ns.OptionsSpacer(order)
    return {type = "description", name = " ", order = order}
end

function ns.OptionsSubHeader(text, order)
    return {type = "description", name = "\n" .. GetColor("TITLE") .. text .. "|r", fontSize = "medium", order = order}
end
