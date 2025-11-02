# AstroFluxUtil

[![Build Status](https://github.com/noahfranz13/AstroFluxUtil.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/noahfranz13/AstroFluxUtil.jl/actions/workflows/CI.yml?query=branch%3Amain)

A package for quick conversions of astronomy flux/flux density/magnitude units. This is very much under development but should (eventually) support
1. Fluxes (energy/time/distance^2)
2. Flux Densities (energy/time/distance^2/frequency AND energy/time/distance^2/wavelength)
3. Logarithmic Magnitude units
4. Converting between any of the above three for any photometry at any wavelength/frequency. 

This package is written in julia to make it **fast**, but I will add python wrappers once a basic version of the julia code is written.

### A note on the Filters used
The `src/filters` directory was initially copied from https://github.com/griffin-h/lightcurve_fitting and much of the `Filter` struct code was heavily influenced by how filters are handled in that package. Anyone that uses the Filters in this package should also cite https://zenodo.org/records/11405219 
