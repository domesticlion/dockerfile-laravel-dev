FROM centos

MAINTAINER SATOSHI ONOZUKA domesticlion@gmail.com

ENV PATH $PATH:/usr/bin

RUN cd /tmp \
	&& yum -y update \
	&& yum clean all \
	&& yum -y install \
		wget \
		epel-release \
	&& wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm \
	&& rpm -ivh ./remi-release-7.rpm \
	&& wget http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm \
	&& rpm -ivh nginx-release-centos-7-0.el7.ngx.noarch.rpm \
	&& yum -y --enablerepo=epel,remi,remi-php70 install \
		vim \
		php70 \
		php70-php-fpm \
		php70-php-mcrypt \
		php70-php-mbstring \
		php70-php-mysql \
		php70-php-gd \
		php70-php-pecl-imagick \
		php70-php-pecl-imagick-devel \
		php70-php-xml \
		php70-php-pecl-zip \
		mysql \
		supervisor \
		nginx \
		composer \
	&& cp -p /etc/opt/remi/php70/php.ini /etc/opt/remi/php70/php.ini.org \
	&& cp -p /etc/opt/remi/php70/php-fpm.d/www.conf /etc/opt/remi/php70/php-fpm.d/www.conf.org

COPY nginx.conf /etc/nginx/
COPY php.ini /etc/opt/remi/php70/
COPY www.conf /etc/opt/remi/php70/php-fpm.d/
COPY supervisord.conf /etc/
COPY bootstrap.sh /tmp/
COPY bash_profile /root/.bash_profile
COPY bashrc /root/.bashrc

RUN chmod 755 /tmp/bootstrap.sh

EXPOSE 80
CMD ["/bin/bash", "/tmp/bootstrap.sh"]