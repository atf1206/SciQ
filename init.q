
// Initializer for SciQ
// Andrew Fritz 2018

.sq.init:{[sciqDir]
	system "l ",sciqDir,$["/"~-1#sciqDir;"";"/"],"stats/stats.q";
	"Sci Q Loaded Successfully"
 };

/ .sq.sciqDir:first system"pwd";
/ .sq.init[.sq.sciqDir];

"Set .sq.sciqDir to the base of the SciQ directory (as a string), then run .sq.init[sciqDir]"
