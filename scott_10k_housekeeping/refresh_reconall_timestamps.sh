
#!/bin/bash
#PBS -l walltime=06:00:00
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -N refresh_reconall
#PBS -o /rds/general/project/c3nl_scott_students/ephemeral/sankeith/scott_10k_logs/recon_all/
#PBS -e /rds/general/project/c3nl_scott_students/ephemeral/sankeith/scott_10k_logs/recon_all/

outdir=/rds/general/project/c3nl_scott_students/ephemeral/sankeith/reconall_scott_10k

for i in $(seq 1 1000); do
    echo ${i}
    cd ${outdir}
    find . -print0 | while IFS= read -r -d '' path;
      do touch "$path" ;
    done
done
