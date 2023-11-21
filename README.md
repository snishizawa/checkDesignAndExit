# About
Procedure to check your design in IC Compiler and exit. This procedure checks following points in the design. This will generate flag ${design}.drc and exit if the following condition(s) are not satisfied.
1. Cell utilization. It check utilization is higher than "lower threshold" and less than "higher threshold".
2. Number of DRCs.
3. Legality of placement.

# How to use?
icc_shell> source checkDesignAndExit.tcl  
icc_shell> set design "b16"  
icc_shell> set stage "floorplan"  
icc_shell> ::checkDesignAndExit $design $stage

# Extension
${design}.drc can be utilize as the flag of design failure. We can skip operation or iteration if we dound ${design}.drc generated from the procedure.
