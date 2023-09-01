MAGS, = glob_wildcards('MAGs/{m}.fa.gz.sig')
METAGENOMES, = glob_wildcards('metagenomes/{m}.sig')

print(METAGENOMES)
print(MAGS)

rule all:
    input:
        expand('outputs/{m}.cont.csv', m=MAGS),
        "branchwater.csv",

rule make_metag_list:
    input:
        expand('metagenomes/{metag}.sig', metag=METAGENOMES),
    output:
        txt="list.metagenomes.txt",
    run:
        with open(output.txt, "wt") as fp:
            for m in input:
                print(m, file=fp)

rule make_mag_list:
    input:
        expand('MAGs/{mag}.fa.gz.sig', mag=MAGS),
    output:
        txt="list.MAGs.txt",
    run:
        with open(output.txt, "wt") as fp:
            for m in input:
                print(m, file=fp)

rule manysearch:
    input:
        mags="list.MAGs.txt",
        metag="list.metagenomes.txt",
    output:
        "branchwater.csv",
    shell: """
        sourmash scripts manysearch {input.mags} {input.metag} \
            -o {output} -c {threads}
    """

rule containment:
    input:
        query = 'MAGs/{m}.fa.gz.sig',
        metag = expand('metagenomes/{m}.sig', m=METAGENOMES),
    output:
        'outputs/{m}.cont.csv',
    shell: """
        sourmash search --containment {input.query} {input.metag} -o {output} \
            --threshold=0
    """
