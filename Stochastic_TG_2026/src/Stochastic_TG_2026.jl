module Stochastic_TG_2026

 # PACKAGES USED for solving equations
    using Base
    using DifferentialEquations
    #using DelaunayTriangulation
    using LinearAlgebra
    using Random
    using ElasticArrays
    using QuadGK
    using Roots
    using StatsModels
    using GLM
    using Statistics
    using Interpolations
    using NLsolve
    # PACKAGES FOR DATA SMOOTHING
    using Loess
    # PACKAGES USED for benchmarking
    using BenchmarkTools
    # PACKAGES USED for plotting
    using CairoMakie
    using ColorSchemes
    using Colors
    using Images
    import Contour as CTR
    # PACKAGES USED for misc
    #using Comonicon
    using SMTPClient
    using Printf
    using JLD2
    import FilePaths
    using CSV
    #using Tables
    using DataFrames

    # DEVELOPED SIMULATION CODE

    include("Discrete/DataStructs.jl")
    include("Discrete/GeneralEquations.jl")
    include("Discrete/ProblemSetup.jl")

    # discrete simulation code
    include("Discrete/EvolvingInterface/Model/AnalyticSolution.jl")
    include("Discrete/EvolvingInterface/Model/CellBehaviours.jl")
    include("Discrete/EvolvingInterface/Model/CellMechanics.jl")
    include("Discrete/EvolvingInterface/Model/TissueSecretion.jl")
    include("Discrete/EvolvingInterface/Misc.jl")
    include("Discrete/EvolvingInterface/ModifierFncs.jl")
    include("Discrete/EvolvingInterface/PoreBoundaries.jl")
    include("Discrete/EvolvingInterface/PostSimulation.jl")
    include("Discrete/EvolvingInterface/Model/GrowthCallBacks.jl")
    include("Discrete/EvolvingInterface/GrowthODEproblem.jl")
    include("Discrete/EvolvingInterface/GrowthSimulation.jl")

    # analysis
    include("Discrete/EvolvingInterface/Analysis/DistributionStats.jl")
    include("Discrete/EvolvingInterface/Analysis/CellOrientation.jl")
    include("Discrete/EvolvingInterface/Analysis/DataAverages.jl")
    include("Discrete/EvolvingInterface/Analysis/WThAsymmetry.jl")

    #plotting
    include("Discrete/EvolvingInterface/Plotting/GeneralPlotting.jl")
    include("Discrete/EvolvingInterface/Plotting/EmbeddedCellShape.jl")
    include("Discrete/EvolvingInterface/Plotting/ResultsPlot.jl")
    include("Discrete/EvolvingInterface/Plotting/ResultsPlot_CairoMakie.jl")
    include("Discrete/EvolvingInterface/Plotting/TEplotting.jl")
    include("Discrete/EvolvingInterface/Plotting/BGplotting.jl")

end # module Stochastic_TG_2026
