# 2023-branchwater-validate

This repo contains validation code for sourmash branchwater, which supports massive-scale sequence search of genomes and metagenomes using [sourmash](https://sourmash.readthedocs.io/en/latest/) and [FracMinHash](https://www.biorxiv.org/content/10.1101/2022.01.11.475838v2).

Also see:
* [pyo3_branchwater repo](https://github.com/sourmash-bio/pyo3_branchwater)
* [Sourmash Branchwater Enables Lightweight Petabyte-Scale Sequence Search](https://www.biorxiv.org/content/10.1101/2022.11.02.514947v1), Irber, Pierce-Ward, Brown, 2022.
* [Benchmarking repo](https://github.com/dib-lab/2022-branchwater-benchmarking).

## Initializing

```
mkdir metagenomes
mkdir MAGs

cd MAGs/
sourmash sketch dna -p k=31 --name-from *.gz
cd ..

for i in $(cat orig-list.txt); do
cp /group/ctbrowngrp/irber/data/wort-data/wort-sra/sigs/$i.sig metagenomes/
done
```

## Running

```
srun -p high2 --time=2:00:00 --nodes=1 --cpus-per-task 8 --mem 40GB 

snakemake -j 8
```
