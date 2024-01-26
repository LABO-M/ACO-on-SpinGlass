using ArgParse
include("simulation.jl")
include("output.jl")

function main(args)
    s = ArgParseSettings()

    @add_arg_table! s begin
        "--N"
        help = "Number of questions (quizzes)"
        default = 10
        arg_type = Int

        "--T"
        help = "Total number of time steps"
        default = 1_000_000
        arg_type = Int

        "--t0"
        help = "Initial time steps for initialization"
        default = 1
        arg_type = Int

        "--alpha"
        help = "Exponent parameter alpha"
        default = 0.5
        arg_type = Float64

        "--tau"
        help = "Time scale of the pheromone evaporation. Use '-1' for infinite tau."
        default = 10
        arg_type = Int
        
        "--sample"
        help = "Sample size."
        default = 10
        arg_type = Int

        "--h"
        help = "Magnetic field"
        default = 0.01
        arg_type = Float64

        "--C"
        help = "Constant C for the pheromone value"
        default = 2.0
        arg_type = Float64

    end

    parsed_args = parse_args(args, s)
    N = parsed_args["N"]
    T = parsed_args["T"]
    t0 = parsed_args["t0"]
    alpha = parsed_args["alpha"]
    tau = parsed_args["tau"]
    sample = parsed_args["sample"]
    h = parsed_args["h"]
    C = parsed_args["C"]

    # Log the simulation parameters
    tau_str = (tau == -1) ? "inf" : int_to_SI_prefix(tau)
    println("Running simulation with the following parameters:")
    println("N = $(int_to_SI_prefix(N)), T = $(int_to_SI_prefix(T)), t0 = $(int_to_SI_prefix(t0)), alpha = $(alpha), tau = $(tau_str), sample = $(int_to_SI_prefix(sample)), h = $(h)")

    # Run the simulation
    Z_mean, Z_std = Simulation.sample_ants(N, T, t0, alpha, tau, sample, h, C)

    # Output Z values to CSV
    dir_Z = "data/Zt"
    if !isdir(dir_Z)
        mkpath(dir_Z)
    end
    filename_Z = joinpath(dir_Z, "N$(int_to_SI_prefix(N))_T$(int_to_SI_prefix(T))_t0$(int_to_SI_prefix(t0))_alpha$(alpha)_tau$(tau_str)_h$(h).csv")
    save_Z_to_csv(Z_mean, Z_std, filename_Z)
    end

# Entry point of the script
isinteractive() || main(ARGS)
