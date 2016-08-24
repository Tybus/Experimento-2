
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name MIniAlu -dir "/home/david/Documents/Digitales/MIniAlu/planAhead_run_1" -part xc3s500efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/david/Documents/Digitales/MIniAlu/MiniAlu.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/david/Documents/Digitales/MIniAlu} }
set_property target_constrs_file "/home/david/Documents/Digitales/Proyecto 1/MiniAlu.ucf" [current_fileset -constrset]
add_files [list {/home/david/Documents/Digitales/Proyecto 1/MiniAlu.ucf}] -fileset [get_property constrset [current_run]]
link_design
