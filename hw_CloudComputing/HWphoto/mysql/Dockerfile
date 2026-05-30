FROM ubuntu

# installing mysql-server. the 2 line before it are so that the installation doesnt stop
RUN ln -s /bin/true /etc/init.d/mysql
RUN echo "exit 0" > /usr/sbin/policy-rc.d
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install mysql-server -y
RUN rm /etc/init.d/mysql
RUN rm /usr/sbin/policy-rc.d

# so that external container can connect to mysql 
RUN sed -E "s/^bind-address\s+=\s+127.0.0.1/bind-address            = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf -i.backup

# the entrypoint will be a shellscript
#    - volume mounted /var/lib/mysql will have root:root
COPY --chmod=500 ./entrypoint.sh /opt/entrypoint.sh

EXPOSE 3306
VOLUME /var/lib/mysql
ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["mysqld"]
