
#!/bin/bash
#PBS -l walltime=00:30:00
#PBS -l select=1:ncpus=1:mem=5gb
#PBS -N scott10k_thresh_scrapereconall
#PBS -o /rds/general/project/c3nl_scott_students/ephemeral/sankeith/scott_10k_logs/recon_all/
#PBS -e /rds/general/project/c3nl_scott_students/ephemeral/sankeith/scott_10k_logs/recon_all/

module load Python/3.13.1-GCCcore-14.2.0
source /rds/general/user/sk4724/home/venv_1/bin/activate

python /rds/general/project/c3nl_scott_students/live/sankeith/scott_10k_housekeeping/scrapereconall_thresh.py
