#!/bin/bash

# Export required environment variables
export UID=$(id -u)
export GID=$(id -g)

# Create directories without sudo (dev container should have permissions)
mkdir -p data init

# Create sample data files
cat > "data/S6A_Livestock_Stock.csv" << 'EOF'
survey_no,hhn,species,livestock,date
R1,101,Cattle,5,2024-01-01
R1,102,Goat,12,2024-01-01
R2,101,Cattle,4,2024-02-01
EOF

cat > "data/S6C_Livestock_Losses.csv" << 'EOF'
survey_no,hhn,species,loss_type,loss_count,date
R1,101,Cattle,drought,1,2024-01-15
R2,102,Goat,disease,2,2024-02-10
EOF

# Restart containers
docker compose down && docker compose up -d
