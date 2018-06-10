FROM ubuntu:18.04

RUN apt update
RUN apt install -y \
    git \
    curl \
    cron \
    wget \
    zsh \
    nano \
    supervisor \
    nginx \
    npm

RUN apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Supervisor conf
RUN echo "[supervisord]" >> /etc/supervisor/supervisord.conf
RUN echo "nodaemon = true" >> /etc/supervisor/supervisord.conf
RUN echo "user = root" >> /etc/supervisor/supervisord.conf

RUN echo "[program:nginx]" >> /etc/supervisor/supervisord.conf
RUN echo "command = /usr/sbin/nginx" >> /etc/supervisor/supervisord.conf
RUN echo "autostart = true" >> /etc/supervisor/supervisord.conf
RUN echo "autorestart = true" >> /etc/supervisor/supervisord.conf

RUN echo "[program:cron]" >> /etc/supervisor/supervisord.conf
RUN echo "command = cron -f" >> /etc/supervisor/supervisord.conf
RUN echo "autostart = true" >> /etc/supervisor/supervisord.conf
RUN echo "autorestart = true" >> /etc/supervisor/supervisord.conf


# Install Zsh
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
RUN sed -i "s/robbyrussell/af-magic/" ~/.zshrc
RUN echo TERM=xterm >> /root/.zshrc

# Add certbot
# https://certbot.eff.org/
RUN wget -P /usr/sbin/ https://dl.eff.org/certbot-auto
RUN chmod a+x /usr/sbin/certbot-auto

RUN chown -R root:root /etc/cron.d
RUN chmod -R 0644 /etc/cron.d

CMD ["/usr/bin/supervisord"]

# Install node
RUN npm install -g n
RUN n stable
RUN npm install -g webpack webpack-cli pm-2
