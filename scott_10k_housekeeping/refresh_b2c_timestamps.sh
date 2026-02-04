
#!/bin/bash
#PBS -l walltime=01:00:00
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -N refresh_b2c
#PBS -o /rds/general/project/c3nl_scott_students/ephemeral/sankeith/scott_10k_logs/b2c/
#PBS -e /rds/general/project/c3nl_scott_students/ephemeral/sankeith/scott_10k_logs/b2c/

outdir=/rds/general/project/c3nl_scott_students/ephemeral/sankeith/scott_10k_20aug25/

cd ${outdir}
find . -type f -print0 | while IFS= read -r -d '' path;
  do touch "$path" ;
done

#rsync -av /rds/general/project/c3nl_scott_students/ephemeral/sankeith/scott_10k_20aug25/ /rds/general/project/c3nl_scott_students/live/data/sankeith/scott_10k_b2c/

#rm /rds/general/user/sk4724/home/java*
