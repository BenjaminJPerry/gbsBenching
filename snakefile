# 2022 Benjamin J Perry
# MIT License
# Copyright (c) 2022 Benjamin J Perry
# Version: 1.0
# Maintainer: Benjamin J Perry
# Email: ben.perry@agresearch.co.nz

configfile: "config/config.yaml"

import os

onstart:
    print(f"Working directory: {os.getcwd()}")
    print("TOOLS: ")
    os.system('echo "  bash: $(which bash)"')
    os.system('echo "  PYTHON: $(which python)"')
    os.system('echo "  CONDA: $(which conda)"')
    os.system('echo "  SNAKEMAKE: $(which snakemake)"')
    os.system('echo "  PYTHON VERSION: $(python --version)"')
    os.system('echo "  CONDA VERSION: $(conda --version)"')
    print(f"Env TMPDIR={os.environ.get('TMPDIR', '<n/a>')}")

# Define samples from data directory using wildcards
SAMPLES, = glob_wildcards('') #TODO

rule target:
    input:
        expand('', samples=SAMPLES) #TODO



rule vsearch_derep:
    input:
        ''
    output:
        ''

rule vsearch_denoise:
    input:
        ''
    output:
        ''

rule vsearch_clust:
    input:
        ''
    output:
    ''

rule dada2ASVs:
    input:
        ''
    output:
        ''

rule porechop:  # rule template for init.
    input:
        'fastq/flongle.{samples}.fastq.gz'
    output:
        '1_chop/{samples}.chop.fastq.gz'
    threads: 4
    log:
        'logs/{samples}/porechop.log'
    conda:
        'workflow/envs/porechop.yaml'
    params:
        checks=config['porechop']['check_reads'],
        adpthresh=config['porechop']['adapter_threshold'],
        midthresh=config['porechop']['middle_threshold'],
        splitlen=config['porechop']['min_split_size']
    resources:
        tempdir=config['TMPDIR']
    message:
        'Chopping: {wildcards.samples}\n'
        'TMPDIR: {resources.tempdir}'
    shell:
        'porechop '
        '--threads {threads} '
        '--verbosity 1 '
        '--format fastq.gz '
        '--check_reads {params.checks} '
        '--adapter_threshold {params.adpthresh} '
        '--middle_threshold {params.midthresh} '
        '--min_split_read_size {params.splitlen} '
        '-i {input} '
        '-o {output} '
        '2>&1 | tee {log}'
