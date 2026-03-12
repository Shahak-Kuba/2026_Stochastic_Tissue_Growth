import Stochastic_TG_2026 as MCTG
using JLD2
using Makie, CairoMakie, ImageMagick, FileIO, Images

function replace_black_with_transparency(img)
    # Convert the image to an array of RGBA values
    rgba_img = Array{RGBA{N0f8}}(img)
    
    # Replace black (RGB(0, 0, 0)) with transparency (RGBA(0, 0, 0, 0))
    for i in 1:size(rgba_img, 1)
        for j in 1:size(rgba_img, 2)
            if rgba_img[i, j] == RGBA(0.0, 0.0, 0.0, 1.0)  # Check if pixel is black
                rgba_img[i, j] = RGBA(0.0, 0.0, 0.0, 0.0)  # Replace black with transparency
            end
        end
    end
    
    return rgba_img
end

for ii in eachindex(all_solutions)
    sol = all_solutions[ii]
    embedded_cells = all_embedded_cell_pos[ii]
    f1,f2 = MCTG.PlotGrowthSimulation_ImageStack(sol, embedded_cells)

    interface_evol = Makie.colorbuffer(f1)
    interface_evol_transparent = replace_black_with_transparency(interface_evol)

    embedded = Makie.colorbuffer(f2)
    embedded_transparent = replace_black_with_transparency(embedded)

    Img_name_I = "BoneSim_I_$(ii).png"
    Img_name_E = "BoneSim_E_$(ii).png"

    dir_interfeace = pwd() * "/Objective_2/Paper2_1/Simulation_Scripts/Bone_Remodelling/Bone_Growth_imgs/" * Img_name_I
    dir_embedded = pwd() * "/Objective_2/Paper2_1/Simulation_Scripts/Bone_Remodelling/Bone_Growth_imgs/" * Img_name_E
    
    save(dir_interfeace, interface_evol_transparent)
    save(dir_embedded, embedded_transparent)

    Img_tiff = "BoneSim_$(ii).tiff"
    dir_tiff = pwd() * "/Objective_2/Paper2_1/Simulation_Scripts/Bone_Remodelling/Bone_Growth_imgs/" * Img_tiff
    
    run(`magick $dir_interfeace $dir_embedded $dir_tiff`)

    # removing the png files
    rm(dir_interfeace)
    rm(dir_embedded)
end

f1,f2 = MCTG.PlotGrowthSimulation_ImageStack(sol, embedded_cells)

CairoMakie.save(dir, f1; px_per_unit=2.0)