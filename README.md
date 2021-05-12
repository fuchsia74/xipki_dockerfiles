# xipki_dockerfiles

git clone https://github.com/fuchsia74/xipki_dockerfiles.git

cd XIPKI_server

# build docker image 
docker build -t xipki_server:1.0 .

# build xipki database image, init database  from sql first run.
cd ../XIPKI_db

docker build -t xipki_db:1.0 .

#now you have tow docker images

root@Docker:~/xipki_docker# docker images

REPOSITORY     TAG                                IMAGE ID       CREATED          SIZE

xipki_server   1.0                                ee54b0b2bf53   10 days ago      479MB

xipki_db       1.0                                3abd827d78e6   11 days ago      406MB

tomcat         9.0.45-jdk11-adoptopenjdk-openj9   a12ac25b14a1   2 weeks ago      465MB

# Create private network for servers
docker network create --subnet 1.1.1.0/24 --internal net-xipki

# Create container from images and run
docker create -p 3306:3306 --name XIPKI_Mysql -v /opt/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456  --network net-xipki xipki_db:1.0

docker create -p 8080:8080 -p 8443:8443 --name XIPKI --network net-xipki xipki_server:1.0

docker start XIPKI_Mysql

docker start XIPKI

# connet tomcat server to public network

docker network connect bridge XIPKI


