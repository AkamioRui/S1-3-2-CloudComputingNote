FROM ubuntu

RUN apt update && apt install php php-mysql -y
RUN apt install mysql-client -y # only dev

WORKDIR /opt
COPY ./myapp/ ./ 

EXPOSE 8080
CMD ["php", "-S", "0.0.0.0:8080"]
