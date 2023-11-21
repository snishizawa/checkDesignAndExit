
proc ::checkDesignAndExit { design stage } {
# exit when cells does not fit to area
	set cell_util [get_utilization]
	if {$cell_util < -0.99} then { 
		echo "Error: Exit icc, floorplan failes, stage: $stage"
		echo $cell_util
		redirect ${design}.drc { echo "Error: Exit icc, floorplan failes" }
		save_mw_cel -design ${design}
		quit 
	}
	set high_threshold 0.95
	if {$cell_util > $high_threshold} then { 
		echo "Error: Exit icc, cell area exceeds die areas, stage: $stage"
		echo $cell_util
		redirect ${design}.drc { echo "Error: Exit icc, cell area exceeds die area" }
		save_mw_cel -design ${design}
		quit 
	}
	set low_threshold 0.30
	if {$cell_util > $high_threshold} then { 
		echo "Error: Exit icc, cell area is too smalls, stage: $stage"
		echo $cell_util
		save_mw_cel -design ${design}
		quit 
	}

# exit when too many DRC errors available
	set collection_drc [get_drc_errors]
	set list_drc [get_object_name $collection_drc]
	set num_drc [llength $list_drc]
	set drc_threshold 100
	if {$num_drc > $drc_threshold} then {
		echo "Error: Exit icc, too many DRCs $num_drc"
		echo $num_drc
		redirect ${design}.drc { echo "Error: Exit icc, too many DRCs $num_drc, stage: $stage" }
		save_mw_cel -design ${design}
		quit 
	}

# exit when cells are not legaly placed 
	redirect ${design}.legal {check_legality}
  set fid [open ${design}.legal r]  
  while {![eof $fid]} {
    set line [gets $fid]
    if {[string match "*PSYN-215*" $line]} {
  		close $fid
			echo "Not legalized placed!"
			redirect ${design}.drc { echo "Error: Exit icc, cells not legalized placed, stage: $stage" }
      quit
    }
	} 
  close $fid
	echo "Legalized placed!"
}
