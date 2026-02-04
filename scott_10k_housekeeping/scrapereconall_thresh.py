
import os
import glob
import pandas as pd

subjects_dir = "/rds/general/project/c3nl_scott_students/ephemeral/sankeith/reconall_scott_10k/"
output_file = "/rds/general/project/c3nl_scott_students/live/data/sankeith/scott_10k_reconall_scraped/BA_exvivo_thresh_summary.txt"
hemis = ["lh", "rh"]
parc = "BA_exvivo.thresh.stats"

all_data = {}

for hemi in hemis:
    files = glob.glob(os.path.join(subjects_dir, "*", "stats", f"{hemi}.{parc}"))
    for fpath in files:
        # Extract subject from directory two levels up from the file path
        subject = os.path.basename(os.path.dirname(os.path.dirname(fpath)))
        if subject not in all_data:
            all_data[subject] = {}

        with open(fpath, 'r') as f:
            for line in f:
                # Skip comment and empty lines
                if line.startswith("#") or line.strip() == "":
                    continue
                parts = line.strip().split()
                # Only parse lines with at least 10 columns (data lines)
                if len(parts) < 10:
                    continue

                # StructName is parts[0]
                label = f"{hemi}_{parts[0]}"

                # Parse and store relevant fields from columns:
                # SurfArea = parts[2], ThickAvg = parts[4], MeanCurv = parts[6]
                all_data[subject][f"{label}_thickness"] = float(parts[4])
                all_data[subject][f"{label}_area"] = float(parts[2])
                all_data[subject][f"{label}_meancurv"] = float(parts[6])

# Convert the collected data into a DataFrame, with subject IDs as index
df = pd.DataFrame.from_dict(all_data, orient='index')
df.index.name = "Subject"
df = df.sort_index(axis=1)

# Save the DataFrame to a tab-separated text file
df.to_csv(output_file, sep='\t', na_rep='NA')
print(f"Saved summary table to {output_file}")
