# docker-redis
amholdings/docker-lamp

Docker Conainer for LAMP on CentOS7

# Build Container:
git clone https://github.com/amholdings/docker-lamp.git

cd docker-lamp

docker build --tag="docker-lamp" .

# Run Container as daemon:

docker run -d --name "docker-lamp" -p 80:80 -p 3306:3306 amholdings/docker-lamp
