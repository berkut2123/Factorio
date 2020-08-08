exemptions={
    ["AutomaticTrainPainter"]={"manual-color-module"},
    ["Shuttle_Train_Continued"]={"shuttle-lite"},
    ["FARL"]={"farl-roboport"},
}

function exemption_check(train)
    for _,v in pairs(exemptions) do
        if train.front_stock.grid and train.front_stock.grid.equipment then
            for _, eq in pairs(train.front_stock.grid.equipment) do
                if eq.name == v[1] then
                    return true
                end
            end
        end
    end
    return false
end