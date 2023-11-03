# Build and query Metagraph indexes

This repository contains a (snakemake) workflow to build Metagraph indexes and bash scripts to run queries against the indexes that have been used for the experiments in this paper [https://doi.org/10.1101/2023.07.21.550101](https://doi.org/10.1101/2023.07.21.550101).

### Dependencies

- `snakemake` v7.30 (recommended installation via `conda`);
- `metagraph`, commit [5c2a12b](https://github.com/ratschlab/metagraph/tree/5c2a12bd26cba5c5f8a15e7b9aa765aeebfe3474).

### Usage

    snakemake --cores all --configfile <config.yml> -- <rule>

Rules to produce various annotations:

- `row_diff`
- `row_diff_flat`
- `row_diff_sparse`
- `row_diff_brwt`
- `relax_brwt_arity`

For example:

    snakemake --cores 48 --configfile se-150k.yml -- relax_brwt_arity

**Note:** building any of the variants produces the "plain" variant that is not row-diff compressed.

### Extracting build times

Use provided python script to sum build times for metagraph variants:

    python gather_build_times.py <path_to_log_dir> <mode>

Logs are written to `<output-dir>/<exp-name>/logs`.

### Config file specification

- outputs are written to `<output-dir>/<exp-name>` with `output-dir` defaulting to `output/<exp-name>` if not specified.
- file containing list of filepaths is specified with `input-file-lists`
- path to `metagraph-bin` metagraph binary must be supplied.
- Number of cores used set to `threads` where possible.

See the file `example-config.yml` for an example.

### Run queries

See the examples provided in the scripts `high_hit_queries.sh` and `low_hit_queries.sh`.

<!--``` YAML
output-dir: output
exp-name: example
input-file-list: test_samples.txt
k: 31

mem-cap-gb: 50
threads: 10

# Annotate step uses different parallization scheme
anno-file-chunk: 5
anno-threads-per-chunk: 4

# BRWT annotation step needs another param. Not sure what this does
brwt-parallel-nodes: 10
relaxed-brwt-arity: 32

metagraph-bin: /mnt/scratch1/rob/wabi_2023/binaries/metagraph
disk-swap: tmp #path to swapfile
```-->

<!--## Notes

- We dont use `metagraph build --mode canonical` because it is not recommended (not compatible?) with `RowDiff<*>`
-->