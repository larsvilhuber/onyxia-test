# Pass variables into the file
ARG VERSION=r4.5.2
ARG TYPE=onyxia-rstudio
ARG SVERSION=2026-01-14
ARG STYPE=19_5-mp-i

FROM dataeditors/stata$STYPE:$SVERSION AS stata

FROM inseefrlab/$TYPE:$VERSION

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y  \
    && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
         libncurses6 \
         libcurl4 \
         git \
         nano \
         unzip \
         locales \
         fontconfig fonts-dejavu-core fonts-dejavu-extra \
         fonts-liberation \
    && rm -rf /var/lib/apt/lists/* \
    && fc-cache -fv \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

COPY --from=stata /usr/local/stata/ /usr/local/stata/
COPY statalic.sh /usr/local/stata/

RUN chmod +x /usr/local/stata/statalic.sh \
    && chmod a+rwX /usr/local/stata \
    && ln -s /usr/local/stata/stata-mp /usr/local/bin/stata-mp

USER onyxia

