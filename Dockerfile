FROM uniqrn/perl-fcgi
MAINTAINER Paul Klumpp
ENV HTDOCS /usr/local/apache2/htdocs
ENV DATA /opt/dada
ENV WDIR /root/wdir
VOLUME ["$DATA", "$HTDOCS"]

RUN usermod -d $DATA daemon
RUN mkdir -p $DATA && chown -R daemon:daemon $DATA && chmod 2755 $DATA
RUN mkdir -p $WDIR 

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y apt-utils
RUN apt-get install -y cron curl build-essential vim 

RUN apt-get install -y libxml-perl libsoap-lite-perl libdbd-mysql-perl libnet-dns-perl libhtml-tree-perl libio-socket-ssl-perl libcrypt-ssleay-perl libxmlrpc-lite-perl libgravatar-url-perl
#ENV PERL_MM_USE_DEFAULT=1
#ENV PERL_EXTUTILS_AUTOINSTALL="--defaultdeps"
RUN curl -L https://cpanmin.us | perl - --force App::cpanminus
RUN apt-get install -y pkg-config libgd-dev libcurl4-openssl-dev libxml2-dev
RUN cpanm -i Image::Resize WWW::StopForumSpam CSS::Inliner Bundle::DadaMail # this failed so hard before.

COPY httpd.conf /usr/local/apache2/conf/

WORKDIR $WDIR
#COPY ./dada-10_7_0.tar.gz ./
RUN pwd && curl -L -O https://netcologne.dl.sourceforge.net/project/dadamail/dada-10_7_0.tar.gz
RUN curl -L -O https://raw.github.com/justingit/dada-mail/v10_7_0-stable_2017_07_05/uncompress_dada.cgi
RUN ls -l
RUN cd $WDIR && /usr/bin/perl -T $WDIR/uncompress_dada.cgi && rm uncompress_dada.cgi && cp -rv $WDIR/* $HTDOCS/

RUN echo '*/5 * * * * /usr/bin/curl --user-agent "Mozilla/5.0 (compatible;)" --silent --get --url http://localhost/dada/mail.cgi/_schedules/_all/_all/_silent/' > /var/spool/cron/crontabs/root 
RUN mkdir -p $HTDOCS/dada_mail_support_files && chown -R daemon:daemon $HTDOCS && chmod 2755 $HTDOCS


USER root
CMD service cron start && httpd-foreground

# http://localhost:8080/dada/installer/install.cgi
