#!/bin/bash

rm -rf cmd logs
mkdir -p cmd logs

i=0
for input in sharded/*.parquet; do
	name=$(basename "$input" .parquet)
	cat > cmd/$i.sh <<EOF
#!/bin/bash
./run_one.sh $input output/${name}_picto.parquet
EOF
	chmod +x cmd/$i.sh
	i=$(expr $i + 1)
done

cat > job.sbatch <<EOF
#!/bin/bash
#SBATCH --array=0-$(expr $i - 1)%128
#SBATCH --time 20:0:0
#SBATCH -A fev@a100 
#SBATCH --partition=gpu_p5 
#SBATCH -C a100 
#SBATCH --gres=gpu:1 
#SBATCH --hint=nomultithread 
#SBATCH --cpus-per-task=16 
#SBATCH --output=logs/%a.stdout
#SBATCH --error=logs/%a.stderr
#SBATCH --job-name=picto

cmd/\$SLURM_ARRAY_TASK_ID.sh
EOF

