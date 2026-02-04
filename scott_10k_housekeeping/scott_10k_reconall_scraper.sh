#!/bin/bash
#PBS -l walltime=01:00:00
#PBS -l select=1:ncpus=1:mem=10gb
#PBS -N scrapescott10k_safe
#PBS -o /rds/general/project/c3nl_scott_students/ephemeral/sankeith/scott_10k_logs/recon_all/
#PBS -e /rds/general/project/c3nl_scott_students/ephemeral/sankeith/scott_10k_logs/recon_all/

module load FreeSurfer/7.4.1-centos8_x86_64
module load FSL/6.0.5.1-foss-2021a
module load MATLAB/2024b

export JOB_NUM=$(echo ${PBS_JOBID} | cut -f 1 -d '.' | cut -f 1 -d '[')
export NEW_TMPDIR="${EPHEMERAL}/${JOB_NUM}.${PBS_ARRAY_INDEX}"
mkdir -p ${NEW_TMPDIR}
export TMPDIR=${NEW_TMPDIR}

export SUBJECTS_DIR="/rds/general/project/c3nl_scott_students/ephemeral/sankeith/reconall_scott_10k/"
export MINTSCRIPTS="/rds/general/project/c3nl_scott_students/live/data/sankeith/scott_10k_reconall_scraped"
export FS_LICENSE="/rds/general/user/sk4724/home/license.txt"

mkdir -p ${MINTSCRIPTS}

echo "SUBJECTS_DIR: ${SUBJECTS_DIR}"

# Function to safely list subjects that have a given .stats file
get_subjects_with_stats() {
    local statfile="$1"
    find "${SUBJECTS_DIR}" -maxdepth 1 -mindepth 1 -type d \
        -exec test -f "{}/stats/${statfile}" \; -print | xargs -n1 basename
}

# --- Aseg stats tables ---
aseg_subjects=$(get_subjects_with_stats "aseg.stats")
if [ -n "$aseg_subjects" ]; then
    echo "Processing aseg stats for subjects:"
    echo "$aseg_subjects"
    asegstats2table --subjects $aseg_subjects --meas volume --skip --tablefile ${MINTSCRIPTS}/aseg_stats.txt
    asegstats2table --subjects $aseg_subjects --meas volume --skip --statsfile wmparc.stats --all-segs --tablefile ${MINTSCRIPTS}/wmparc_stats.txt
fi

# --- Aparc stats (Desikan) ---
for hemi in lh rh; do
    for meas in volume thickness area meancurv; do
        aparc_subjects=$(get_subjects_with_stats "${hemi}.aparc.stats")
        if [ -n "$aparc_subjects" ]; then
            echo "Processing ${hemi} aparc stats (${meas}) for subjects:"
            echo "$aparc_subjects"
            aparcstats2table --subjects $aparc_subjects --hemi $hemi --meas $meas --skip \
                --tablefile ${MINTSCRIPTS}/aparc_${meas}_${hemi}.txt
        fi
    done
done

# --- Aparc stats (a2009s) ---
for hemi in lh rh; do
    for meas in volume thickness area meancurv; do
        aparc_subjects=$(get_subjects_with_stats "${hemi}.aparc.a2009s.stats")
        if [ -n "$aparc_subjects" ]; then
            echo "Processing ${hemi} aparc.a2009s stats (${meas}) for subjects:"
            echo "$aparc_subjects"
            aparcstats2table --subjects $aparc_subjects --hemi $hemi --parc aparc.a2009s --meas $meas --skip \
                -t ${MINTSCRIPTS}/${hemi}.a2009s.${meas}.txt
        fi
    done
done

# --- BA_exvivo ---
for hemi in lh rh; do
    for meas in volume thickness area meancurv; do
        aparc_subjects=$(get_subjects_with_stats "${hemi}.BA_exvivo.stats")
        if [ -n "$aparc_subjects" ]; then
            echo "Processing ${hemi} BA_exvivo stats (${meas}) for subjects:"
            echo "$aparc_subjects"
            aparcstats2table --subjects $aparc_subjects --hemi $hemi --parc BA_exvivo --meas $meas --skip \
                -t ${MINTSCRIPTS}/${hemi}.BA_exvivo.${meas}.txt
        fi
    done
done

echo "All tables processed successfully."
