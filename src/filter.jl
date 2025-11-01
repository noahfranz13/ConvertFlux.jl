"""
Struct representing a telescope filter or band. This is meant to be a general "filter"
that can be applied to any wavelength (e.g., you could put a "radio transmission function"
in, although I'm not entirely sure what that looks like!)
"""
struct Filter
    filter_name::String
    transmission_wav::Vector{AbstractFloat}
    transmission::Vector{AbstractFloat}
    min_wav::Quantity
    max_wav::Quantity
    function Filter(filter_name, transmission_wav, transmission)
        min_wav = min(transmission_wav)
        max_wav = max(transmission_wav)
        new(filter_name, transmission_wav, transmission, min_wav, max_wav)
    end
end

"""
construct a filter from a file with the transmission function
"""
function filter_from_file(filepath)
    # 1) read the file

    # 2) parse the file into a Filter object
end
