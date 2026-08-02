FROM ubuntu:26.10

RUN apt-get update && apt-get install -y \
    curl \
    emacs-nox \
    fd-find \
    fonts-symbola \
    fzf \
    gcc \
    git \
    lazygit \
    maven \
    openjdk-25-jdk \
    ripgrep \
    sqlite3 \
    unzip \
    vim \
    wget
RUN ln -s /usr/bin/fdfind /usr/bin/fd

WORKDIR /tmp/jtdls
RUN wget -q -O server.tar.gz https://download.eclipse.org/jdtls/milestones/1.60.0/jdt-language-server-1.60.0-202606262232.tar.gz
RUN mkdir -p /opt/jdt-language-server-latest
RUN tar xzf server.tar.gz -C /opt/jdt-language-server-latest --no-same-owner --no-same-permissions
RUN ln -s /opt/jdt-language-server-latest/bin/jdtls /usr/local/bin/jdtls
WORKDIR /root
RUN rm -rf /tmp/jtdls

RUN git clone --depth 1 https://github.com/doomemacs/core ~/.emacs.d
RUN git config --global core.hooksPath ""
RUN .emacs.d/bin/doom install --env

COPY config.el .doom.d/config.el
COPY init.el .doom.d/init.el
RUN .emacs.d/bin/doom sync

#RUN mkdir -p /config /work /root/.local/share /root/.local/state

COPY *.sh /root/

ENTRYPOINT ["bash", "/root/entrypoint.sh"]

#ENTRYPOINT ["bash"]
