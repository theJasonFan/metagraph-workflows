## Dependencies

- `snakemake` v7.30 (recommended installation via `conda`)
- `metagraph` v0.3.6

## Usage

    snakemake --cores all --configfile <config.yml> -- <rule>

Rules to produce various annotations
- `row_diff`
- `row_diff_flat`
- `row_diff_sparse`
- `row_diff_brwt`
- `relax_brwt_arity` for relaxed brwt annotation

*Note:* building any of the variants produces the "plain" variant that is not row-diff compressed.

### Extracting build times:

Use provided python script to sum build times for metagraph variants:

    python gather_build_times.py <path_to_log_dir> <mode>

Logs are written to '<output-dir>/<exp-name>/logs'.

## Config file specification

- outputs are written to `<output-dir>/<exp-name>` with `output-dir` defaulting to `output/<exp-name>` if not specified.
- file containing list of filepaths is specified with `input-file-lists`
- path to `metagraph-bin` metagraph binary must be supplied.
- Number of cores used set to `threads` where possible.

``` YAML
output-dir: output
exp-name: example
input-file-list: test_samples.txt
k: 31

mem-cap-gb: 50
threads: 10

# Annotate step uses different parallization scheme
anno-file-chunk: 5
anno-threads-per-chunk: 4

# BRWT annotation step needs another param.
brwt-parallel-nodes: 10
relaxed-brwt-arity: 32

metagraph-bin: /mnt/scratch1/rob/wabi_2023/binaries/metagraph
disk-swap: tmp #path to swapfile
```

## Notes

- We dont use `metagraph build --mode canonical` because it is not recommended/compatible with `RowDiff<*>`
