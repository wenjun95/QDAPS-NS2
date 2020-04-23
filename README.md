# QDAPS-NS2
This is the code of QDAPS which is implemented in NS2 simulator.

We also provide a test demo for the verification. The test topology is leaf-spine, which includes two leaf switches and four spine switches.

1. Install ns2.35

2. Enter the ns-2.35 directory
`cd ns-2.35`

3. Enter to the `/classifier`, `/queue` and `/tcl/lib` directories and replace the corresponding files, respectively.

4. Copy the 'test' directory to the ns-2.35 directory and enter the `\test` directory:
`../ns testtopo.tcl`

Note that you should modify the `#include` statement according to actual path in  `classifier-mpath.cc` and `testtopo.tcl` files
