docker build -t hipeac-2024 .

docker run -it -d --gpus all -v .:/home/hipeac-2024 --log-opt max-size=50m --privileged hipeac-2024 /bin/bash