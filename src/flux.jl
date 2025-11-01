"A struct representing anything with units energy/time/distance^2"
struct Flux
    quantity::Quantity
    function Flux(quantity)
        isflux(quantity)
        new(quantity)
    end
end

"Validate that the input flux is actually a flux with the correct units"
function isflux(v::Quantity)
    if dimension(v) != dimension(u"erg/s/cm^2")
        error("The dimension of $v does not match the dimension of flux (energy/time/distance^2)")
    end
end
