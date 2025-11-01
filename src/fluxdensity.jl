include("./filter.jl")

"A struct representing anything with units energy/time/distance^2"
struct FluxDensity
    quantity::Quantity
    filter::Filter
    quantity_wav::Quantity
    quantity_nu::Quantity
    function FluxDensity(quantity, filter)

        isfluxdensity(quantity)

        if _isperwav(quantity)
            quantity_wav = quantity
            quantity_nu = u"c"/quantity

        elseif _ispernu(quantity)
            quantity_wav = u"c"/quantity
            quantity_nu = quantity

        end

        new(quantity, filter, quantity_wav, quantity_nu)
    end
end

"Validate that the input flux is actually a flux with the correct units"
function isfluxdensity(v::Quantity)
    if dimension(v) != dimension(u"erg/s/cm^2/Hz") && dimension(v) != dimension(u"erg/s/cm^2/nm")
        error("The dimension of $v does not match the dimension of flux density")
    end
end

function _isperwav(v::Quantity)
    return dimension(v) == dimension(u"erg/s/cm^2/nm")
end

function _ispernu(v::Quantity)
    return dimension(v) == dimension(u"erg/s/cm^2/Hz")
end
