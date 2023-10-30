import os
import sys
import logging
import datetime

timing_logs = [
'build.time', # graph
'transform.time', # graph small
'annotate.time', # annotate
]

mode_logs = {}
mode_logs['plain'] = []
mode_logs['row_diff'] = [
    'transform_anno_stage_0.time', # row_diff
    'transform_anno_stage_1.time',
    'transform_anno_stage_2.time'
]
mode_logs['row_diff_sparse'] = mode_logs['row_diff'] + [ 'transform_anno_row_diff_sparse.time' ]
mode_logs['row_diff_brwt'] = mode_logs['row_diff'] +  ['transform_anno_row_diff_brwt.time' ]
mode_logs['relax_brwt_arity'] = mode_logs['row_diff_brwt'] + ['relax_brwt_arity.time']

def get_sec(t):
    # get sec from h:mm:ss or mm:ss.ms string
    tot = 0
    t = t.split(".")[0]
    for i, v in enumerate(reversed(t.split(":"))):
        if i > 2:
            logging.exception("Could not properly parse units > hours into seconds!")
        tot += int(v) * (60**i)
    return tot

def get_sec_from_file(fp):
    with open(fp, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith('Elapsed (wall clock) time'):
                time_str = line.split(' ')[-1]
                secs = get_sec(time_str)
                return secs
    logging.exception("Could not parse .time file to find elapsed time!")
            
def main():
    keys = list(mode_logs.keys())
    if len(sys.argv) != 2 or sys.argv[1] == '-h':
        print('Usage: python <script> <path_to_logs> <mode>')
        print(f'    (supported modes: {keys})')
        exit()

    logs_dir = sys.argv[1]
    mode = sys.argv[2]
    
    if mode not in mode_logs.keys(): 
        print(f'"{mode}" not one of suported modes: {keys}')
        exit(1)
    
    files = timing_logs + mode_logs[mode]
    files = [os.path.join(logs_dir, f) for f in files]

    total_seconds = [get_sec_from_file(f) for f in files]
    total_seconds = sum(total_seconds)

    print("Gathered total build time for all metagraph steps:")
    print(f"* Mode: {mode}")
    print(f"* Total seconds: {total_seconds}")
    
    fmt_time = str(datetime.timedelta(seconds=total_seconds))
    print(f"* Elapsed (h:mm:ss): {fmt_time}")

if __name__ == "__main__":
    main()
