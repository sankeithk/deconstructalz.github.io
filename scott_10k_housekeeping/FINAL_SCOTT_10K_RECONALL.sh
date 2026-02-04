
#!/bin/bash
#PBS -l walltime=72:00:00
#PBS -l select=1:ncpus=1:mem=30gb
#PBS -J 1-9999
#PBS -N reconall_scott_10k
#PBS -o /rds/general/project/c3nl_scott_students/ephemeral/sankeith/scott_10k_logs/recon_all/
#PBS -e /rds/general/project/c3nl_scott_students/ephemeral/sankeith/scott_10k_logs/recon_all/

inpath=`head -n ${PBS_ARRAY_INDEX} /rds/general/project/c3nl_scott_students/live/sankeith/scott_10k_housekeeping/missing_reconall_list.txt| tail -n 1`
infile=`basename $inpath .nii.gz`;

echo ${infile}

outdir=/rds/general/project/c3nl_scott_students/ephemeral/sankeith/reconall_scott_10k
mkdir -p "$outdir"

module load tools/prod
module load FreeSurfer/7.4.1-centos8_x86_64 > /dev/null 2>&1
#module load freesurfer/7.2.0 > /dev/null 2>&1 ## for CX1
module load FSL/6.0.5.1-foss-2021a > /dev/null 2>&1
#module load fsl/6.0.5 > /dev/null 2>&1 ##for CX1
module load MATLAB/2024b > /dev/null 2>&1
#module load matlab/2017a > /dev/null 2>&1 ##for CX1

export JOB_NUM=$(echo ${PBS_JOBID} | cut -f 1 -d '.' | cut -f 1 -d '[')
export NEW_TMPDIR="${EPHEMERAL}/${JOB_NUM}.${PBS_ARRAY_INDEX}"
mkdir -p ${NEW_TMPDIR}
export TMPDIR=${NEW_TMPDIR}
export SUBJECTS_DIR="/rds/general/project/scott_data_adni/live/ADNI/ADNI_NIFTI/ADNI_allT1/"
export FS_LICENSE="${HOME}/license.txt"

cmd="recon-all -all -i ${inpath} -subjid ${infile} -sd ${outdir}"
echo ${cmd}
${cmd}

## Runs every 1000 jobs - will update timestamps of all reconall jobs so they don't expire in ephemeral ##
mod=${PBS_ARRAY_INDEX}%1000
if [[ "$mod" -eq 0 ]]; then
    echo "updating timestamps..."
    cd ${outdir}
    find . -print0 | while IFS= read -r -d '' path
        do touch "$path" ;
    done
fi
