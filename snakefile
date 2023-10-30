from os.path import join, realpath

# root output directory output/<exp-name> unless 'output-dir' provided to config
OUTPUT_DIR = config.get('output-dir', 'output')
OUTPUT_DIR = join(OUTPUT_DIR, config['exp-name'])

# inputs
FILE_LIST = config['input-file-list']

# parameters
DISK_SWAP = config['disk-swap']
K = config['k']
MEM_CAP_GB = config['mem-cap-gb']
THREADS = config['threads']
RELAXED_BRWT_ARITY = config['relaxed-brwt-arity']

## Annotation requires different parallelization params
FILES_PER_CHUNK = config['anno-file-chunk']
THREADS_PER_FILE = config['anno-threads-per-chunk']

## BRWT params
BRWT_PARALLEL_NODES = config['brwt-parallel-nodes']

# outputs
## graphs

graph_name = 'graph'
graph_prefix = join(OUTPUT_DIR, graph_name)
OUTPUT_GRAPH = '{}.dbg'.format(graph_prefix)

graph_small_prefix = join(OUTPUT_DIR, 'graph_small')
OUTPUT_GRAPH_SMALL = '{}.dbg'.format(graph_small_prefix)
## intermediate files
OUTPUT_COLUMNS_DIR = join(OUTPUT_DIR, 'columns')

RD_DIR = join(OUTPUT_DIR, 'rd')
RD_COLUMNS_DIR = join(RD_DIR, 'columns')
RD_COLUMNS_OUT = join(RD_COLUMNS_DIR, 'out')
RD_GRAPH = join(RD_DIR, '{}.dbg'.format(graph_name))

## annotations
row_diff_flat_ext         = '.row_diff_flat.annodbg'
row_diff_sparse_ext       = '.row_diff_sparse.annodbg'
row_diff_disk_ext         = '.row_diff_disk.annodbg'
row_diff_brwt_ext         = '.row_diff_brwt.annodbg'
relaxed_row_diff_brwt_ext = '.relaxed.row_diff_brwt.annodbg'

ANNOTATION_PREFIX = join(OUTPUT_DIR, 'annotation')
RD_FLAT_OUTPUT = ANNOTATION_PREFIX + row_diff_flat_ext
RD_SPARSE_OUTPUT = ANNOTATION_PREFIX + row_diff_sparse_ext
RD_DISK_OUTPUT= ANNOTATION_PREFIX + row_diff_disk_ext
RD_BRWT_OUTPUT = ANNOTATION_PREFIX + row_diff_brwt_ext
RELAXED_BRWT_ARITY_OUTPUT = ANNOTATION_PREFIX + relaxed_row_diff_brwt_ext

## logs and timing info
LOGS_DIR = join(OUTPUT_DIR, 'logs')
BUILD_TIME = join(LOGS_DIR, 'build.time')
TRANSFORM_TIME = join(LOGS_DIR, 'transform.time')
ANNOTATE_TIME = join(LOGS_DIR, 'annotate.time')
ANNO_STAGE_0_TIME = join(LOGS_DIR, 'transform_anno_stage_0.time')
ANNO_STAGE_1_TIME = join(LOGS_DIR, 'transform_anno_stage_1.time')
ANNO_STAGE_2_TIME = join(LOGS_DIR, 'transform_anno_stage_2.time')

ROW_DIFF_FLAT_TIME = join(LOGS_DIR, 'transform_anno_row_diff_flatt.time')
ROW_DIFF_SPARSE_TIME = join(LOGS_DIR, 'transform_anno_row_diff_sparse.time')
ROW_DIFF_DISK_TIME = join(LOGS_DIR, 'transform_anno_row_diff_disk.time')
ROW_DIFF_BRWT_TIME = join(LOGS_DIR, 'transform_anno_row_diff_brwt.time')
RELAX_BRWT_ARITY_TIME = join(LOGS_DIR, 'relax_brwt_arity.time')

# binaries
time = '/usr/bin/time'
metagraph= config.get('metagraph-bin', 'metagraph')

rule build_graph:
    input:
        FILE_LIST
    output:
        time = BUILD_TIME,
        graph = OUTPUT_GRAPH,
    params:
        output_prefix = graph_prefix,
    threads: THREADS,
    shell: 
        '''
        cat {input} \
        | {time} -o {output.time} -v \
        {metagraph} build -v \
            -k {K} \
            --mem-cap-gb {MEM_CAP_GB} \
            --disk-swap {DISK_SWAP} \
            -p {threads} \
            -o {params.output_prefix}
        '''
# transform the graph to 'small' state
rule graph_small:
    input: OUTPUT_GRAPH,
    output:
        time = TRANSFORM_TIME,
        graph = OUTPUT_GRAPH_SMALL,
    threads: THREADS,
    params:
        output_prefix = graph_small_prefix,
    shell:
        '''
        {time} -o {output.time} -v \
        {metagraph} transform -v --state small \
            -p {threads} \
            -o {params.output_prefix} \
            {input}
        '''

# Annotates the 'graph'
# Graph small is required by this rule so that it we always have it for query
rule annotate:
    input: 
        graph = OUTPUT_GRAPH,
        graph_small = OUTPUT_GRAPH_SMALL, # graph small is always built even though later rules don't use it
        file_list = FILE_LIST,
    output:
        time = ANNOTATE_TIME,
        columns = directory(OUTPUT_COLUMNS_DIR)
    params:
        files_per_chunk = FILES_PER_CHUNK,
        threads_each = THREADS_PER_FILE,
    shell:
        '''
        mkdir -p {output.columns} && \
        cat {input.file_list} | \
        {time} -o {output.time} -v \
        {metagraph} annotate -v \
            -i {input.graph} \
            --anno-filename \
            --separately \
            -o {output.columns} \
            -p {params.files_per_chunk} \
            --threads-each {params.threads_each}
        '''

# temp files
rule rd:
    input:
        graph = OUTPUT_GRAPH,
    output:
        graph = RD_GRAPH,
        rd_columns = directory(RD_COLUMNS_DIR),
    params:
        graph_full_path = realpath(OUTPUT_GRAPH),
        rd_dir = RD_DIR,
    shell: 
        '''
        echo Cleaning up {params.rd_dir} && \
        rm -rf {params.rd_dir} && \
        mkdir -p {params.rd_dir} && \
        ln -s {params.graph_full_path} {output.graph} && \
        mkdir {output.rd_columns} && \
        echo Linked {input.graph} to {output.graph} and mkdir-d {output.rd_columns}
        '''


rule row_diff_0:
    input:
        columns = OUTPUT_COLUMNS_DIR,
        graph = RD_GRAPH
    output:
        time = ANNO_STAGE_0_TIME,
    params:
        rd_columns_out = RD_COLUMNS_OUT,
        stage = 0,
    threads: THREADS,
    shell:
        '''
        find {input.columns} -name "*.annodbg" \
        | {time} -o {output.time} -v \
        {metagraph} transform_anno -v \
            --anno-type row_diff \
            --row-diff-stage {params.stage} \
            -i {input.graph} \
            -o {params.rd_columns_out} \
            --disk-swap {DISK_SWAP} \
            --mem-cap-gb {MEM_CAP_GB} \
            -p {threads} \
        '''

rule row_diff_1:
    input:
        columns = OUTPUT_COLUMNS_DIR,
        graph = RD_GRAPH,
        _prev_stage = ANNO_STAGE_0_TIME,
    output:
        time = ANNO_STAGE_1_TIME,
    params:
        rd_columns_out = RD_COLUMNS_OUT,
        stage = 1,
    threads: THREADS,
    shell:
        '''
        find {input.columns} -name "*.annodbg" \
        | {time} -o {output.time} -v \
        {metagraph} transform_anno -v \
            --anno-type row_diff \
            --row-diff-stage {params.stage} \
            -i {input.graph} \
            -o {params.rd_columns_out} \
            --disk-swap {DISK_SWAP} \
            --mem-cap-gb {MEM_CAP_GB} \
            -p {threads} \
        '''

rule row_diff_2:
    input:
        columns = OUTPUT_COLUMNS_DIR,
        graph = RD_GRAPH,
        _prev_stage = ANNO_STAGE_1_TIME,
    output:
        time = ANNO_STAGE_2_TIME,
    params:
        rd_columns_out = directory(RD_COLUMNS_OUT),
        stage = 2,
    threads: THREADS,
    shell:
        '''
        find {input.columns} -name "*.annodbg" \
        | {time} -o {output.time} -v \
        {metagraph} transform_anno -v \
            --anno-type row_diff \
            --row-diff-stage {params.stage} \
            -i {input.graph} \
            -o {params.rd_columns_out} \
            --disk-swap {DISK_SWAP} \
            --mem-cap-gb {MEM_CAP_GB} \
            -p {threads} \
        '''

rule row_diff:
    input:
        _prev_stage = ANNO_STAGE_2_TIME, # hack to link 3 stages

## transform the row-diff to row-diff-flat
rule row_diff_flat:
    input:
        rd_columns = RD_COLUMNS_DIR,
        graph = RD_GRAPH,
        _prev_stage = ANNO_STAGE_2_TIME, # Hack to link row_diff rules as predecesssors
    output:
        time = ROW_DIFF_FLAT_TIME,
        annotation = RD_FLAT_OUTPUT,
    params:
        output = ANNOTATION_PREFIX
    threads: THREADS
    shell:
        ''' 
        find {input.rd_columns} -name "*.annodbg" \
        | {time} -o {output.time} -v \
        {metagraph} transform_anno -v \
        --anno-type row_diff_flat \
        -i {input.graph} \
        -o {params.output} \
        -p {threads}
        '''
## transform the row-diff-flat to row-diff-sparse
rule row_diff_sparse:
    input:
        rd_columns = RD_COLUMNS_DIR,
        graph = RD_GRAPH,
        _prev_stage = ANNO_STAGE_2_TIME,
    output:
        time = ROW_DIFF_SPARSE_TIME,
        annotation = RD_SPARSE_OUTPUT,
    params:
        output = ANNOTATION_PREFIX
    threads: THREADS
    shell:
        ''' 
        find {input.rd_columns} -name "*.annodbg" \
        | {time} -o {output.time} -v \
        {metagraph} transform_anno -v \
        --anno-type row_diff_sparse \
        -i {input.graph} \
        -o {params.output} \
        -p {threads}
        '''

rule row_diff_brwt:
    input:
        rd_columns = RD_COLUMNS_DIR,
        graph = RD_GRAPH,
        _prev_stage = ANNO_STAGE_2_TIME,
    output:
        time = ROW_DIFF_BRWT_TIME,
        annotation = RD_BRWT_OUTPUT,
    params:
        output = ANNOTATION_PREFIX
    threads: THREADS
    shell:
        ''' 
        find {input.rd_columns} -name "*.annodbg" \
        | {time} -o {output.time} -v \
        {metagraph} transform_anno -v \
        --anno-type row_diff_brwt \
        --greedy \
        -i {input.graph} \
        -o {params.output} \
        --disk-swap {DISK_SWAP} \
        -p {threads} --parallel-nodes {BRWT_PARALLEL_NODES}
        '''

rule relax_brwt_arity:
    output:
        time = RELAX_BRWT_ARITY_TIME,
        anno = RELAXED_BRWT_ARITY_OUTPUT
    input: RD_BRWT_OUTPUT
    threads: THREADS
    shell:
        '''
        {time} -o {output.time} -v \
        {metagraph} relax_brwt -v \
        -p {threads} \
        --relax-arity {RELAXED_BRWT_ARITY} \
        -o {output.anno} \
        {input}
        '''
