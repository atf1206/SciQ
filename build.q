
// Build assistant for SciQ
// Andrew Fritz 2018

.sq.build:{[sciqDir]
	sciqDir:sciqDir,$["/"~-1#sciqDir;"";"/"];
	macOptions:"clang++ -shared -undefined dynamic_lookup";
	system macOptions," -o ",sciqDir,"bin/ndtr.so ",sciqDir,"stats/special/cephes/ndtr.c";
	show "ndtr.so built successfully";
	system macOptions," -o ",sciqDir,"bin/ndtr_sq.so ",sciqDir,"stats/special/cephes/ndtr_sq.c";
	show "ndtr_sq.so built successfully";
	"Sci Q Built Successfully"
 };

/ .sq.sciqDir:first system"pwd";
/ .sq.build[.sq.sciqDir];

"Set .sq.sciqDir to the base of the SciQ directory (as a string), then run .sq.build[sciqDir]"
