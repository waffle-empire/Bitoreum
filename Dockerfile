FROM archlinux:base-devel AS build

RUN pacman -Syy && pacman -S --noconfirm --needed git
RUN pacman -Syy && pacman -S --noconfirm --needed numactl openssl gmp jansson automake zlib

RUN git clone https://github.com/WyvernTKC/cpuminer-gr-avx2.git /build
WORKDIR /build

# disable donations
RUN sed -i "s/enable_donation = true;/enable_donation = false;/" cpu-miner.c
RUN sed -i "s/double donation_percent = 1.75;/double donation_percent = 0.0;/" cpu-miner.c
RUN sed -i "s/donation_percent = (donation_percent < 1.75) ? 1.75 : donation_percent;/donation_percent = (donation_percent < 2.f) ? 0.0 : donation_percent;/" cpu-miner.c
# disable call to swap to donation pool
RUN sed -i "s/    donation_switch();/\/\/    donation_switch();/" cpu-miner.c

RUN ./build.sh

FROM archlinux:base-devel AS deploy

RUN pacman -Syy && pacman -S --noconfirm --needed numactl jansson

WORKDIR /app

COPY --from=build /build/cpuminer .

ENTRYPOINT [ "./cpuminer", "--config=./config.json" ]
