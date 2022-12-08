#!/bin/bash

docker build . -t elixir-pbbs
image_id=$(docker images | awk '{print $3}' | awk 'NR==2')

container_id=$(docker run -d -it "$image_id" /bin/bash)

echo "Container id: $container_id"

docker exec -it "$container_id" sh -c "mix benchmark -a histogram"
docker cp "$container_id":/app/output_histogram.csv experiments_results/output_histogram.csv

docker exec -it "$container_id" sh -c "mix benchmark -a remove_duplicates"
docker cp "$container_id":/app/output_ddup.csv experiments_results/output_ddup.csv

docker exec -it "$container_id" sh -c "mix benchmark -a word_count"
docker cp "$container_id":/app/output_wc.csv experiments_results/output_wc.csv

docker exec -it "$container_id" sh -c "mix benchmark -a ray_cast"
docker cp "$container_id":/app/output_ray_cast.csv experiments_results/output_ray_cast.csv

docker exec -it "$container_id" sh -c "mix benchmark -a convex_hull"
docker cp "$container_id":/app/output_convex_hull.csv experiments_results/output_convex_hull.csv

echo "Experiments done, killng container $container_id..."
docker kill "$container_id"
