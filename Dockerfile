FROM uniqrn/perl-fcgi
MAINTAINER Paul Klumpp
ENV HTDOCS /usr/local/apache2/htdocs
ENV DATA /opt/dada
WORKDIR $HTDOCS
VOLUME ["$DATA", "$HTDOCS"]

RUN usermod -d $DATA daemon
RUN mkdir -p $DATA && chown -R daemon:daemon $DATA && chmod 2755 $DATA

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y apt-utils
RUN apt-get install -y cron curl build-essential vim 

RUN apt-get install -y libxml-perl libsoap-lite-perl libdbd-mysql-perl libnet-dns-perl libhtml-tree-perl libio-socket-ssl-perl libcrypt-ssleay-perl libxmlrpc-lite-perl libgravatar-url-perl
#ENV PERL_MM_USE_DEFAULT=1
#ENV PERL_EXTUTILS_AUTOINSTALL="--defaultdeps"
RUN curl -L https://cpanmin.us | perl - --force App::cpanminus
RUN apt-get install -y pkg-config libgd-dev libcurl4-openssl-dev libxml2-dev
RUN cpanm -i Image::Resize WWW::StopForumSpam CSS::Inliner Bundle::DadaMail # this failed so hard before.

COPY httpd.conf /usr/local/apache2/conf/

#COPY ./dada-10_7_0.tar.gz ./
ADD https://downloads.sourceforge.net/project/dadamail/dada-10_7_0.tar.gz?r=http%3A%2F%2Fdadamailproject.com%2Fsupport%2Fdocumentation-10_7_0%2Finstall_dada_mail.pod.html&ts=1501887836&use_mirror=netcologne ./dada-10_7_0.tar.gz
ADD https://raw.github.com/justingit/dada-mail/v10_7_0-stable_2017_07_05/uncompress_dada.cgi ./

RUN chmod 0755 uncompress_dada.cgi && /usr/bin/perl -T uncompress_dada.cgi && rm uncompress_dada.cgi
RUN echo '*/5 * * * * /usr/bin/curl --user-agent "Mozilla/5.0 (compatible;)" --silent --get --url http://localhost/dada/mail.cgi/_schedules/_all/_all/_silent/' > /var/spool/cron/crontabs/root 
RUN mkdir -p $HTDOCS/dada_mail_support_files && chown -R daemon:daemon $HTDOCS && chmod 2755 $HTDOCS

USER root
CMD service cron start && httpd-foreground

# http://localhost:8080/dada/installer/install.cgi
