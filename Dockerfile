FROM docker.io/debian:12-slim
LABEL maintainer "Andreas Hofmann"

ENV HTDOCS /var/www/dada
ENV HTSUPPORT /var/www/dada/dada_mail_support_files
ENV DATA /opt/dada
ENV WDIR /root/working

VOLUME ["$DATA"]

RUN usermod -d $DATA www-data

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends cron curl apache2 sudo
RUN apt-get install -y libxml-perl libsoap-lite-perl libdbd-mysql-perl libnet-dns-perl libhtml-tree-perl libio-socket-ssl-perl libcrypt-ssleay-perl libxmlrpc-lite-perl libgravatar-url-perl

COPY dadamail.conf /etc/apache2/sites-available/
RUN a2dissite 000-default
RUN a2ensite dadamail
RUN a2enmod cgi

RUN mkdir -p $WDIR $DATA $HTDOCS $HTSUPPORT
WORKDIR $WDIR
RUN curl -L -O https://sourceforge.net/projects/dadamail/files/dada_mail-v11_22_0_stable_2023-09-18.tar.gz
RUN tar xf dada_mail-v11_22_0_stable_2023-09-18.tar.gz
RUN rm dada_mail-v11_22_0_stable_2023-09-18.tar.gz
RUN mv dada/installer-disabled dada/installer

RUN mv dada/* $HTDOCS
RUN chown -R www-data:www-data $HTDOCS $DATA $HTSUPPORT
RUN chmod  755 $HTDOCS/installer/install.cgi
RUN chmod  755 $HTDOCS/mail.cgi

COPY entry.sh /
RUN chmod 755 /entry.sh

USER root
CMD /entry.sh
