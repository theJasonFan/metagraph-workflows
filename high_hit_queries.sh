/usr/bin/time -v -o metagraph_query_logs/coli3682-high-hit-time-no-batch.log ./metagraph query -i ~/metagraph-workflows/metagraph-indexes/ecoli-3682/graph_small.dbg -a ~/metagraph-workflows/metagraph-indexes/ecoli-3682/annotation.relaxed.row_diff_brwt.annodbg -p 16 --fwd-and-reverse --query-mode labels --min-kmers-fraction-label 1.0 --batch-size 0 ~/ENA2018-bacteria-salmonella/salmonella-178829/SRR1928200_1.fastq.gz > /dev/null
/usr/bin/time -v -o metagraph_query_logs/coli3682-high-hit-time-batch.log ./metagraph query -i ~/metagraph-workflows/metagraph-indexes/ecoli-3682/graph_small.dbg -a ~/metagraph-workflows/metagraph-indexes/ecoli-3682/annotation.relaxed.row_diff_brwt.annodbg -p 16 --fwd-and-reverse --query-mode labels --min-kmers-fraction-label 1.0 --batch-size 100000000 ~/ENA2018-bacteria-salmonella/salmonella-178829/SRR1928200_1.fastq.gz > /dev/null

/usr/bin/time -v -o metagraph_query_logs/se-5k-high-hit-time-no-batch.log ./metagraph query -i ~/metagraph-workflows/metagraph-indexes/se-5k/graph_small.dbg -a ~/metagraph-workflows/metagraph-indexes/se-5k/annotation.relaxed.row_diff_brwt.annodbg -p 16 --fwd-and-reverse --query-mode labels --min-kmers-fraction-label 1.0 --batch-size 0 ~/ENA2018-bacteria-salmonella/salmonella-178829/SRR801268_1.fastq.gz > /dev/null
/usr/bin/time -v -o metagraph_query_logs/se-5k-high-hit-time-batch.log ./metagraph query -i ~/metagraph-workflows/metagraph-indexes/se-5k/graph_small.dbg -a ~/metagraph-workflows/metagraph-indexes/se-5k/annotation.relaxed.row_diff_brwt.annodbg -p 16 --fwd-and-reverse --query-mode labels --min-kmers-fraction-label 1.0 --batch-size 100000000 ~/ENA2018-bacteria-salmonella/salmonella-178829/SRR801268_1.fastq.gz > /dev/null

/usr/bin/time -v -o metagraph_query_logs/se-10k-high-hit-time-no-batch.log ./metagraph query -i ~/metagraph-workflows/metagraph-indexes/se-10k/graph_small.dbg -a ~/metagraph-workflows/metagraph-indexes/se-10k/annotation.relaxed.row_diff_brwt.annodbg -p 16 --fwd-and-reverse --query-mode labels --min-kmers-fraction-label 1.0 --batch-size 0 ~/ENA2018-bacteria-salmonella/salmonella-178829/SRR801268_1.fastq.gz > /dev/null
/usr/bin/time -v -o metagraph_query_logs/se-10k-high-hit-time-batch.log ./metagraph query -i ~/metagraph-workflows/metagraph-indexes/se-10k/graph_small.dbg -a ~/metagraph-workflows/metagraph-indexes/se-10k/annotation.relaxed.row_diff_brwt.annodbg -p 16 --fwd-and-reverse --query-mode labels --min-kmers-fraction-label 1.0 --batch-size 100000000 ~/ENA2018-bacteria-salmonella/salmonella-178829/SRR801268_1.fastq.gz > /dev/null

/usr/bin/time -v -o metagraph_query_logs/se-50k-high-hit-time-no-batch.log ./metagraph query -i ~/metagraph-workflows/metagraph-indexes/se-50k/graph_small.dbg -a ~/metagraph-workflows/metagraph-indexes/se-50k/annotation.relaxed.row_diff_brwt.annodbg -p 16 --fwd-and-reverse --query-mode labels --min-kmers-fraction-label 1.0 --batch-size 0 ~/ENA2018-bacteria-salmonella/salmonella-178829/SRR801268_1.fastq.gz > /dev/null
/usr/bin/time -v -o metagraph_query_logs/se-50k-high-hit-time-batch.log ./metagraph query -i ~/metagraph-workflows/metagraph-indexes/se-50k/graph_small.dbg -a ~/metagraph-workflows/metagraph-indexes/se-50k/annotation.relaxed.row_diff_brwt.annodbg -p 16 --fwd-and-reverse --query-mode labels --min-kmers-fraction-label 1.0 --batch-size 100000000 ~/ENA2018-bacteria-salmonella/salmonella-178829/SRR801268_1.fastq.gz > /dev/null

/usr/bin/time -v -o metagraph_query_logs/se-100k-high-hit-time-no-batch.log ./metagraph query -i ~/metagraph-workflows/metagraph-indexes/se-100k/graph_small.dbg -a ~/metagraph-workflows/metagraph-indexes/se-100k/annotation.relaxed.row_diff_brwt.annodbg -p 16 --fwd-and-reverse --query-mode labels --min-kmers-fraction-label 1.0 --batch-size 0 ~/ENA2018-bacteria-salmonella/salmonella-178829/SRR801268_1.fastq.gz > /dev/null
/usr/bin/time -v -o metagraph_query_logs/se-100k-high-hit-time-batch.log ./metagraph query -i ~/metagraph-workflows/metagraph-indexes/se-100k/graph_small.dbg -a ~/metagraph-workflows/metagraph-indexes/se-100k/annotation.relaxed.row_diff_brwt.annodbg -p 16 --fwd-and-reverse --query-mode labels --min-kmers-fraction-label 1.0 --batch-size 100000000 ~/ENA2018-bacteria-salmonella/salmonella-178829/SRR801268_1.fastq.gz > /dev/null

/usr/bin/time -v -o metagraph_query_logs/30k-gut-high-hit-time-no-batch.log ./metagraph query -i ~/metagraph-workflows/metagraph-indexes/30k-gut/graph_small.dbg -a ~/metagraph-workflows/metagraph-indexes/30k-gut/annotation.relaxed.row_diff_brwt.annodbg -p 16 --fwd-and-reverse --query-mode labels --min-kmers-fraction-label 1.0 --batch-size 0 ~/ENA2018-bacteria-salmonella/salmonella-178829/ERR321482_1.fastq.gz > /dev/null
/usr/bin/time -v -o metagraph_query_logs/30k-gut-high-hit-time-batch.log ./metagraph query -i ~/metagraph-workflows/metagraph-indexes/30k-gut/graph_small.dbg -a ~/metagraph-workflows/metagraph-indexes/30k-gut/annotation.relaxed.row_diff_brwt.annodbg -p 16 --fwd-and-reverse --query-mode labels --min-kmers-fraction-label 1.0 --batch-size 100000000 ~/ENA2018-bacteria-salmonella/salmonella-178829/ERR321482_1.fastq.gz > /dev/null