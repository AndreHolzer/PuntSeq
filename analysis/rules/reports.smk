rule plot_post_filtering:
    input:
        rules.filtlong.output
    output:
        "data/{run}/plots/{sample}_filtered.pdf"
    log:
        "logs/pistis_{run}_{sample}.log"
    resources:
        mem_mb = lambda wildcards, attempt: attempt * 3000
    params:
        downsample = config["plot_downsample"]
    shell:
        """
        pistis --fastq {input} --output {output} \
          --downsample {params.downsample} 2> {log}
        """


rule stats_post_filtering:
    input:
        rules.filtlong.output
    output:
        "data/{run}/stats/{sample}_stats.txt"
    log:
        "logs/nanostat_{run}_{sample}.log"
    threads: 4
    resources:
        mem_mb = lambda wildcards, attempt: attempt * 4000
    shell:
        """
        NanoStat --fastq {input} --name {output} --threads {threads} \ 
          --readtype 1D 2> {log}
        """

