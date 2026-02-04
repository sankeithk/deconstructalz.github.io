
#!/bin/bash
#PBS -l walltime=01:45:00
#PBS -l select=1:ncpus=1:mem=20gb
#PBS -N scott_10k_b2c
#PBS -J 0-10
#PBS -o /rds/general/project/c3nl_scott_students/ephemeral/sankeith/scott_10k_logs/b2c/
#PBS -e /rds/general/project/c3nl_scott_students/ephemeral/sankeith/scott_10k_logs/b2c/

inpath=`head -n ${PBS_ARRAY_INDEX} /rds/general/project/c3nl_scott_students/live/sankeith/scott_10k_housekeeping/missing_mwc1t1_list.txt | tail -n 1`
infile=`basename $inpath .nii.gz`;

echo "inpath: $inpath";
echo "infile: $infile";

outdir=/rds/general/project/c3nl_scott_students/ephemeral/sankeith/scott_10k_20aug25
mkdir -p ${outdir}
cd ${outdir}

echo "outdir: ${outdir}"

cmd="/rds/general/project/scott_code/live/brain2cog/brain2cog.sh -i \"$inpath\" -o \"$outdir/$infile\""
echo "$cmd"
eval "$cmd"

# cd "$outdir/$infile" || exit 1

# find "$outdir/$infile/" -type f -not -name 'mwc1t1*.nii*' \
#     ! -path "*/task/*" \
#     ! -path "*/net/*" \
#     ! -path "*/fd/*" \
#     ! -path "*/fdinfo/*" \
#     ! -path "*/map_files/*" \
#     ! -path "*/ns/*" \
#     ! -path "*/sys/*" \
#     ! -path "*/proc/*" \
#     -delete

cd ${outdir}
find . -type f -print0 | while IFS= read -r -d '' path;
  do touch "$path" ;
done

rm ~/java*
rm ~/*crash_dump*
