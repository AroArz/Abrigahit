# vim: syntax=python expandtab tabstop=4
# MEGAHIT & ABRICATE
# Aron Arzoomand 6/3 2020

SAMPLES = glob_wildcards("input/{sample}_R1.fastq").sample
print(SAMPLES)

rule all:
    input:
        expand("output_megahit/{sample}/{sample}.contigs.fa", sample=SAMPLES)

rule megahit:
    input:
            read1="input/{sample}_R1.fastq",
            read2="input/[sample]_R2.fastq",
    output:
            contigs="output_megahit/{sample}/{sample}.contigs.fa"
    conda:
            "envs/env.yaml"
    shell:
            """
            rm -rvf output_megahit/{wildcard.sample}
            megahit \
            -1 {input.read1} \
            -2 {input.read2} \
            -o output_megahit/{wildcards.sample} \
            --out--prefix {wildcards.sample} 
            """

rule collect_contigs:
    input:
            all_contigs=expand("output_megahit/{sample}/{sample}.contigs.fa", sample=SAMPLES),
            contigs="output_megahit/{sample}/{sample}.contigs.fa",
    output:
            collected_contigs="contigs/{sample}.contigs.fa"
    shell:
            """
            cp {input.contigs} contigs/
            """

rule abricate:
    input:
            input_contigs=expand("contigs/{sample}.contigs.fa", sample=SAMPLES),
            single_contigs="contigs/{sample}.contigs.fa",
    output:
            abricate_output="abricate_output/{sample}"
    conda:
            "envs/env.yaml"
    shell:
            """
            abricate-get_db --db megares
            abricate \
            --db megares \
            {input.single_contigs} > {output.abricate_output}
            """

rule abricate_summary:
    input:
            expand("abricate_output/{sample}", sample=SAMPLES),
    output:
            "abricate_output/summary"
    conda:
            "envs/env.yaml"
    shell:
            """
            abricate \
            --summary \
            {input} > {output}
            """

