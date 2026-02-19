# Open packaged Vivado snapshot project from repo root.
set script_dir [file normalize [file dirname [info script]]]
set repo_root [file normalize [file join $script_dir ".."]]
set xpr_path [file join $repo_root "prj" "prj.xpr"]
set impl_dcp_path [file join $repo_root "prj" "prj.runs" "impl_1" "design_1_wrapper_routed.dcp"]
set synth_dcp_path [file join $repo_root "prj" "prj.runs" "synth_1" "design_1_wrapper.dcp"]

if {![file exists $xpr_path]} {
  error "Snapshot project not found: $xpr_path"
}

open_project $xpr_path
puts "Opened snapshot project: $xpr_path"

# On some clone environments, "Open Implemented Design" fails due run metadata.
# In that case, directly open the routed checkpoint from the repo snapshot.
if {[file exists $impl_dcp_path]} {
  if {[catch {open_checkpoint $impl_dcp_path} impl_err]} {
    puts "WARN: Failed to open routed checkpoint: $impl_err"
  } else {
    puts "Opened routed checkpoint: $impl_dcp_path"
  }
} elseif {[file exists $synth_dcp_path]} {
  if {[catch {open_checkpoint $synth_dcp_path} synth_err]} {
    puts "WARN: Failed to open synthesized checkpoint: $synth_err"
  } else {
    puts "Opened synthesized checkpoint: $synth_dcp_path"
  }
} else {
  puts "INFO: No checkpoint file found. Open runs manually in Vivado."
}
