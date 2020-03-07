# Abrigahit

Abrigahit, the Snakefile that will take your quality filtered paired ends, assemble them through megahit, and finally screen the contigs for antimicrobial resistance or virulence genes.
This Snakefile was designed to be compatible with Rackham cluster on UPPMAX and Slurm workscheduler, it might however be compatible with other clusters.

## What do I need to get started?
1. [Snakemake](https://snakemake.readthedocs.io)
2. [Miniconda](https://conda.io/minoconda.html)
3. +/- Slurm workscheduler

## How do I get started?

### Installation
Snakemake use conda to retrieve both megahit, abricate and other required dependencies in a virtual environment. You need to install [Miniconda](https://conda.io/miniconda.html) and then install [Snakemake](https://snakemake.readthedocs.io) either onto the base environment or in a new virtual environment.

### Git clone
Clone this repository into a directory of your choosing.

```bash
git clone https://github.com/AroArz/Abrigahit.git
```
This will create a local copy of this repository with all the necessary requirements.

### Input files
Create a symbolic link to your input files

```bash
ln -s /path/to/your/input/files input
```
Your input files need to reflect the pattern `{sample}.1.fq`. You can either change the name of your input files using the `mv` command or change the pattern in the Snakefile using `vi Snakefile`.

If you are not using paired-end fastq files as input you have to change `input` and `shell` sections of `rule megahit:` in your Snakefiles, please see [this](https://github.com/voutcn/megahit).

### Update your cluster configurations
To assign the correct account, partition, time and cores for Snakemake to relay Slurm please type
```bash
vi cluster_configs/rackham/rackham.yaml
```
and modify accordingly.

### Execution

Test your configurations by performing a dry-run
```bash
Snakemake --use-conda --dryrun
``` 
Execute your workflow on cluster
```bash
Snakemake --use-conda --profile cluster_configs/rackham --latency-wait 60 --jobs 100
```

## FAQ

### To only run Megahit 
Change `input` for `rule all:` to `expand("output_megahit/{sample}.1.fq", sample=SAMPLES)`

### To only run Abricate
Change pattern for `input_contigs` and `single_contigs` under `rule abricate:` to accurately reflect the path and name of your contigs.

### I want to run Abricate with other databases
Add the databases of your liking under `rule abricate:` more information on what databases are eligible can be found [here](https://github.com/tseemann/abricate).

### Help. My run failed. How do I know what happened?
Failed runs will create log files in
```bash
1. slurm_logs ### With specific information regarding each rule.
2. .snakemake/log
3. megahit_output/{sample}/{sample}.log
```
### My run was killed due to OOM
The most common problem for a failed run is if Slurm kills it due to overconsumption of memory. If this happens change to `--mem-flag 0` in your snakefile under `rule megahit:` If your run is still getting killed by slurm please see [this](https://github.com/voutcn/megahit/wiki/MEGAHIT-Memory-setting) for more information.

## Further reading
[Minoconda](https://conda.io/miniconda.html)
[Snakemake](https://snakemake.readthedocs.io)
[Megahit](https://github.com/voutcn/megahit)
[Megahit memory settings](https://github.com/voutcn/megahit/wiki/MEGAHIT-Memory-setting)
[Even more Megahit information](https://metagenomics.wiki/tools/assembly/megahit)
[Abricate](https://tseenabb/abricate)

