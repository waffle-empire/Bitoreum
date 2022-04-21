FROM archlinux:base-devel AS setup

WORKDIR /dl

RUN pacman -Syy && pacman -S wget --noconfirm
RUN wget https://github.com/WyvernTKC/cpuminer-gr-avx2/releases/download/1.2.4.1/cpuminer-gr-1.2.4.1-x86_64_linux.tar.gz && \
tar xf cpuminer-gr-1.2.4.1-x86_64_linux.tar.gz && \
cd cpuminer-gr-1.2.4.1-x86_64_linux/ && chmod a+x cpuminer.sh

FROM archlinux:base-devel AS deploy

WORKDIR /app

COPY --from=setup /dl/cpuminer-gr-1.2.4.1-x86_64_linux/ .

ENTRYPOINT [ "./cpuminer.sh" ]
