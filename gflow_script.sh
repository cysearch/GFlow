#!/bin/bash -x

# This script is a documented working example of Gflow with a handful of random pairwise computations (until convergence = 1N)
# using 4 cpus on Ubuntu where the current density summation is the only output. 

# Gflow must be compiled locally before executing this script. Dependencies for GFlow include: openmpi, hypre, and petsc.

# Execution flags are annotated below and demonstrate an example execution of GFlow. To execute script as is: type 'sh execute_example.sh'
# in Terminal.

which mpiexec

# Set and add PETSc to PATH (Please update this if you are using Linux or any installation proceedure that differs from the README)
export PETSC_DIR=/usr/lib/petscdir/3.7.3/x86_64-linux-gnu-real
export LD_LIBRARY_PATH=${PETSC_DIR}/lib:$LD_LIBRARY_PATH

# Set the Clock
SECONDS=0
date

# REQUIRED flags to execute GFlow are below. Please read descriptions or see example arguments for use.

	# Set Number of processes (CPUs) and call Gflow.x  - Currently -n = 4 below

	# -habitat
		# Set Habitat Map or resistance surface (.asc)
	# -nodes
		# Set Focal Nodes or Source/Destination Points (.txt list of point pairs OR .asc grid to calculate). Inputs must be points.
		# Node coordinates must be relative to the resistance surface grid. Please look at example inputs.


# OPTIONAL flags

	# -output_density_filename
		# Set Output Path, file name, and format (i.e., *.asc, *.asc.gz) of individual pairwise calculations. Omitting this
		# flag will discard each pairwise solve output and assume you want the cumulative output only. Currently omitted below. Do
		# not use spaces in the filepath.
		# For use see: https://github.com/gflow/GFlow/issues/8
	# -output_sum_density_filename
		# Set Output Path, file name prefix, and format (i.e., *.asc, *.asc.gz) of final summed calculation. If omitted, the final
		# summed current density will be discarded. Do not use spaces in the filepath.
		# For use see: https://github.com/Pbleonard/GFlow/issues/8
	# -node_pairs
		# Calculate only desired node pairs if input. Currently not used. Listed pairs should be referenced by their ID, not their
		# coordinates.
	# -max_distance
		# Only calculate pairs within a given euclidean distance. Units should correspond to input grids (typically meters)
	# -converge_at
		# Set Convergence Factor to stop calculating. Typically used in place of 'node_pairs' or if all pairwise is too
		# computationally time consuming. Acceptable formats include: '4N' or '.9999'. Set to '1N' Below. If omitted, gflow will
		# calculate all pairwise
	# -shuffle_node_pairs
		# Shuffles pairs for random selection. Input is binary. Currently set to shuffle below (= 1)
	# -effective_resistance
		# Print effective resistance to log file. Supply path for .csv

# # gflow will not automatically create the output directory.  Ensure the directories exist, otherwise the program will crash.

GFLOW_PATH="/opt/GFlow/"
RESISTANCE_PATH=$1
NODES_PATH=$2
ALL_PATH=$3
OUTPUT_I_PATH=$4
OUTPUT_REFF_PATH=$5
NB_PROCESSES=$6

echo "GFLOW_PATH : ${GFLOW_PATH}gflow.x"
echo "RESISTANCE_PATH : ${RESISTANCE_PATH}"
echo "NODES_PATH : ${NODES_PATH}"
echo "ALL_PATH : ${ALL_PATH}"
echo "OUTPUT_I_PATH : ${OUTPUT_I_PATH}"
echo "OUTPUT_REFF_PATH : ${OUTPUT_REFF_PATH}"

# Assigning Arguments to Flags for Execution:
mpiexec -n "${NB_PROCESSES}" "${GFLOW_PATH}gflow.x" \
	-habitat "${RESISTANCE_PATH}" \
	-nodes "${NODES_PATH}" \
	-node_pairs "${ALL_PATH}" \
	-shuffle_node_pairs 1 \
	-effective_resistance "${REFF_PATH}" \
	-output_sum_density_filename "${OUTPUT_I_PATH}" \

: "walltime: $SECONDS seconds"

