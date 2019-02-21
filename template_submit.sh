#!/bin/bash
#SBATCH --job-name=fastQC.sample
#SBATCH --account=bm14
#SBATCH --cpus-per-task=1

date
hostname

module load fastqc/0.11.7
module load  fastx-toolkit/0.0.13


PROGRAM

date
