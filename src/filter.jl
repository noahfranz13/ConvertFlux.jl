"""
Struct representing a telescope filter or band. This is meant to be a general "filter"
that can be applied to any wavelength (e.g., you could put a "radio transmission function"
in, although I'm not entirely sure what that looks like!)
"""
struct Filter
    name::String
    filter_names::Vector{String}
    color::Union{String,Nothing}
    offset::Union{Integer,Nothing}
    system::Union{String,Nothing}
    fnu::Union{AbstractFloat,Nothing} 
    filename::Union{String,Nothing}
    angstrom::Bool
    italics::Bool
    transmission_wav::Vector{AbstractFloat}
    transmission::Vector{AbstractFloat}
    min_wav::AbstractFloat
    max_wav::AbstractFloat
end

function Filter(
    filter_names::Union{String, Vector{String}},
    color::String = "k",
    offset::Integer = 0,
    system::Union{String,Nothing} = nothing,
    fnu::Union{AbstractFloat,Nothing} = 3.631e-23
    ; # separates args from kwargs
    filename::Union{String,Nothing} = "",
    angstrom::Bool = false,
    italics::Bool = false
    )

    if typeof(filter_names) == Vector{String}
        name = filter_names[1]
    else
        name = filter_names
        filter_names = [name]
    end
    
    # read in filename
    transmission_wav, transmission = read_transmission_curve(filename)

    # calculate some other properties
    min_wav = 0
    max_wav = Inf
    if length(filename) > 0
        min_wav = min(transmission_wav...)
        max_wav = max(transmission_wav...)
    end
    
    # construct a new Filter struct
    Filter(
        name,
        filter_names,
        color,
        offset,
        system,
        fnu,
        filename,
        angstrom,
        italics,
        transmission_wav,
        transmission,
        min_wav,
        max_wav,
    )

end

"""
construct a filter from a file with the transmission function
"""
function read_transmission_curve(filename)
    currdir = dirname(@__FILE__)
    lines = open("$currdir/filters/$filename") do file
        readlines(file)
    end

    wavs = []
    transmissions = []
    for line in lines
        if occursin(",", line)
            wav, transmission = split(line, ",")
        else
            wav, transmission = split(line)
        end

        try
            append!(wavs, parse(Float64, wav))
            append!(transmissions, parse(Float64, transmission))
        catch e
            if !(isa(e, ArgumentError))
                throw(e)
            end
            continue # this just means there's a header row
        end
    end
    return wavs, transmissions    
end

"""
An array of many common filters
"""
# Vega zero points are from
#  * Table A2 of Bessell et al. 1998, A&A, 333, 231 for UBVRIJHK
#  * Table 1 of https://heasarc.gsfc.nasa.gov/docs/heasarc/caldb/swift/docs/uvot/uvot_caldb_AB_10wa.pdf for Swift
ALL_FILTERS = [
    Filter("FUV", "b", 8, "GALEX", filename="GALEX_GALEX.FUV.dat", angstrom=true),
    Filter("NUV", "r", 8, "GALEX", filename="GALEX_GALEX.NUV.dat", angstrom=true),
    Filter(["UVW2", "uvw2", "W2", "2", "uw2"], "#FF007F", 8, "Swift", 7.379e-24, filename="Swift_UVOT.UVW2.dat", angstrom=true),
    Filter(["UVM2", "uvm2", "M2", "M", "um2"], "m", 8, "Swift", 7.656e-24, filename="Swift_UVOT.UVM2.dat", angstrom=true),
    Filter(["UVW1", "uvw1", "W1", "1", "uw1"], "#7F00FF", 4, "Swift", 9.036e-24, filename="Swift_UVOT.UVW1.dat", angstrom=true),
    Filter(["u", "u'", "up", "uprime"], "#4700CC", 3, "Gunn", filename="SLOAN_SDSS.u.dat", angstrom=true),
    Filter(["U_S", "s", "us"], "#230047", 3, "Swift", 1.419e-23, filename="Swift_UVOT.U.dat", angstrom=true),
    Filter("U", "#3C0072", 3, "Johnson", 1.790e-23, filename="Generic_Johnson.U.dat", angstrom=true),
    Filter("B", "#0057FF", 2, "Johnson", 4.063e-23, filename="Generic_Johnson.B.dat", angstrom=true),
    Filter(["B_S", "b", "bs"], "#4B00FF", 2, "Swift", 4.093e-23, filename="Swift_UVOT.B.dat", angstrom=true),
    Filter(["g", "g'", "gp", "gprime", "F475W"], "#00CCFF", 1, "Gunn", filename="SLOAN_SDSS.g.dat", angstrom=true),
    Filter("g-DECam", "#00CCFF", 1, "DECam", filename="CTIO_DECam.g.dat", angstrom=true),
    Filter(["c", "cyan"], "c", 1, "ATLAS", filename="ATLAS_cyan.txt"),
    Filter("V", "#79FF00", 1, "Johnson", 3.636e-23, filename="Generic_Johnson.V.dat", angstrom=true),
    Filter(["V_S", "v", "vs"], "#00FF30", 1, "Swift", 3.664e-23, filename="Swift_UVOT.V.dat", angstrom=true),
    Filter("Itagaki", "w", 0, "Itagaki", filename="KAF-1001E.asci", italics=false),
    Filter("white", "w", 0, "MOSFiT", filename="white.txt", italics=false),
    Filter(["unfilt.", "0", "C", "clear", "pseudobolometric", "griz", "RGB", "LRGB"], "w", 0, "MOSFiT",
           filename="pseudobolometric.txt", italics=false),
    Filter("G", "w", 0, "Gaia", filename="GAIA_GAIA0.G.dat", angstrom=true),
    Filter("Kepler", "r", 0, "Kepler", filename="Kepler_Kepler.K.dat", angstrom=true, italics=false),
    Filter("TESS", "r", 0, "TESS", filename="TESS_TESS.Red.dat", angstrom=true, italics=false),
    Filter(["DLT40", "Open", "Clear"], "w", 0, "DLT40", filename="QE_E2V_MBBBUV_Broadband.csv", italics=false),
    Filter("w", "w", 0, "Gunn", filename="PAN-STARRS_PS1.w.dat", angstrom=true),
    Filter(["o", "orange"], "orange", 0, "ATLAS", filename="ATLAS_orange.txt"),
    Filter(["r", "r'", "rp", "rprime", "F625W"], "#FF7D00", 0, "Gunn", filename="SLOAN_SDSS.r.dat", angstrom=true),
    Filter("r-DECam", "#FF7D00", 0, "DECam", filename="CTIO_DECam.r.dat", angstrom=true),
    Filter(["R", "Rc", "R_s"], "#FF7000", 0, "Johnson", 3.064e-23, filename="Generic_Cousins.R.dat", angstrom=true),
    Filter(["i", "i'", "ip", "iprime", "F775W"], "#90002C", -1, "Gunn", filename="SLOAN_SDSS.i.dat", angstrom=true),
    Filter("i-DECam", "#90002C", -1, "DECam", filename="CTIO_DECam.i.dat", angstrom=true),
    Filter(["I", "Ic"], "#66000B", -1, "Johnson", 2.416e-23, filename="Generic_Cousins.I.dat", angstrom=true),
    Filter(["z_s", "zs"], "#000000", -2, "Gunn", filename="PAN-STARRS_PS1.z.dat", angstrom=true),
    Filter(["z", "z'", "zp", "zprime"], "#000000", -2, "Gunn", filename="SLOAN_SDSS.z.dat", angstrom=true),
    Filter("z-DECam", "#000000", -2, "DECam", filename="CTIO_DECam.z.dat", angstrom=true),
    Filter("y", "y", -3, "Gunn", filename="PAN-STARRS_PS1.y.dat", angstrom=true),
    Filter("y-DECam", "y", -3, "DECam", filename="CTIO_DECam.Y.dat", angstrom=true),
    Filter("J", "#444444", -2, "UKIRT", 1.589e-23, filename="Gemini_Flamingos2.J.dat", angstrom=true),
    Filter("H", "#888888", -3, "UKIRT", 1.021e-23, filename="Gemini_Flamingos2.H.dat", angstrom=true),
    Filter(["K", "Ks"], "#CCCCCC", -4, "UKIRT", 0.640e-23, filename="Gemini_Flamingos2.Ks.dat", angstrom=true),
    Filter("L", "r", -4, "UKIRT", 0.285e-23),
    # JWST
    Filter("F070W", "C7", 0, "JWST NIRCam", filename="JWST_NIRCam.F070W.dat", angstrom=true, italics=false),
    Filter("F090W", "C0", 0, "JWST NIRCam", filename="JWST_NIRCam.F090W.dat", angstrom=true, italics=false),
    Filter("F115W", "C8", 0, "JWST NIRCam", filename="JWST_NIRCam.F115W.dat", angstrom=true, italics=false),
    Filter("F150W", "C1", 0, "JWST NIRCam", filename="JWST_NIRCam.F150W.dat", angstrom=true, italics=false),
    Filter("F182M", "tomato", 0, "JWST NIRCam", filename="JWST_NIRCam.F182M.dat", angstrom=true, italics=false),
    Filter("F200W", "C2", 0, "JWST NIRCam", filename="JWST_NIRCam.F200W.dat", angstrom=true, italics=false),
    Filter("F250M", "chocolate", 0, "JWST NIRCam", filename="JWST_NIRCam.F250M.dat", angstrom=true, italics=false),
    Filter("F277W", "C3", 0, "JWST NIRCam", filename="JWST_NIRCam.F277W.dat", angstrom=true, italics=false),
    Filter("F300M", "maroon", 0, "JWST NIRCam", filename="JWST_NIRCam.F300M.dat", angstrom=true, italics=false),
    Filter("F335M", "salmon", 0, "JWST NIRCam", filename="JWST_NIRCam.F335M.dat", angstrom=true, italics=false),
    Filter("F356W", "C4", 0, "JWST NIRCam", filename="JWST_NIRCam.F356W.dat", angstrom=true, italics=false),
    Filter("F360M", "crimson", 0, "JWST NIRCam", filename="JWST_NIRCam.F360M.dat", angstrom=true, italics=false),
    Filter("F444W", "C5", 0, "JWST NIRCam", filename="JWST_NIRCam.F444W.dat", angstrom=true, italics=false),
    Filter("F560W", "C9", 0, "JWST MIRI", filename="JWST_MIRI.F560W.dat", angstrom=true, italics=false),
    Filter("F770W", "C6", 0, "JWST MIRI", filename="JWST_MIRI.F770W.dat", angstrom=true, italics=false),
    Filter("F1000W", "C7", 0, "JWST MIRI", filename="JWST_MIRI.F1000W.dat", angstrom=true, italics=false),
    Filter("F1130W", "C0", 0, "JWST MIRI", filename="JWST_MIRI.F1130W.dat", angstrom=true, italics=false),
    Filter("F1280W", "C8", 0, "JWST MIRI", filename="JWST_MIRI.F1280W.dat", angstrom=true, italics=false),
    Filter("F1500W", "C1", 0, "JWST MIRI", filename="JWST_MIRI.F1500W.dat", angstrom=true, italics=false),
    Filter("F1800W", "C9", 0, "JWST MIRI", filename="JWST_MIRI.F1800W.dat", angstrom=true, italics=false),
    Filter("F2100W", "C2", 0, "JWST MIRI", filename="JWST_MIRI.F2100W.dat", angstrom=true, italics=false),
    Filter("F2550W", "C3", 0, "JWST MIRI", filename="JWST_MIRI.F2550W.dat", angstrom=true, italics=false),
    # catch-all
    Filter(["unknown", "?"], "w", 0, "unknown", italics=false)
]

FILTER_DICT = Dict(name => filt for filt in ALL_FILTERS for name in filt.filter_names)        
