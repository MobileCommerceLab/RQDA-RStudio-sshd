# Pulling the SSHD configuration from this image. It's also based on xenial, so
# copying the sshd config file later shouldn't be a problem.
FROM mobilecommercelab/sshd-password AS sshd
RUN echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

FROM rstudio/r-base:3.6.1-xenial

# Dependencies for RQDA and rstudio
RUN apt-get update && apt-get install -y gdebi-core \
  libnss3 \
  libasound2 \
  libglfw3-dev \
  libgles2-mesa-dev \
  libqt5x11extras5 \
  libxtst6 \
  libgtk2.0-dev
# Installation of BH and plogr must be done before RQDA, for some reason
RUN R -e 'install.packages("BH", dependencies=c("Depends", "Imports"), repos="http://cran.us.r-project.org")' \
 && R -e 'install.packages("plogr", dependencies=c("Depends", "Imports"), repos="http://cran.us.r-project.org")' \
 && R -e 'install.packages("RQDA", dependencies=c("Depends", "Imports"), repos="http://cran.us.r-project.org")'
RUN wget https://download1.rstudio.org/desktop/xenial/amd64/rstudio-1.2.1335-amd64.deb \
 && yes | gdebi rstudio-1.2.1335-amd64.deb \
 && rm rstudio-1.2.1335-amd64.deb \
 && mkdir -p /root/.local/share

# Setting the locale, as recommended:
# http://rqda.r-forge.r-project.org/documentation_2.html#tips
RUN apt-get update && apt-get install -y locales && locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# Finish configuring sshd
RUN apt-get update && apt-get install -y openssh-server && mkdir /var/run/sshd
COPY --from=sshd /etc/ssh/sshd_config /etc/ssh/sshd_config
COPY --from=sshd /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]

MAINTAINER pstory@andrew.cmu.edu
