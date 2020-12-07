# development enviroment
FROM alpine AS development
WORKDIR /src
COPY . .
# speed up apk downloading (for China mainland)
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk update && apk upgrade
RUN apk add --no-cache openssl gcc g++ make cmake python2
RUN mkdir build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release -DCLIENT=OFF && make -j$(nproc)

# production enviroment (alpine
FROM alpine AS production
WORKDIR /teeworlds_srv/
# speed up apk downloading (for China mainland)
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk update && apk upgrade
RUN apk add --no-cache openssl libstdc++
COPY --from=development /src/build/data ./data
COPY --from=development /src/build/teeworlds_srv .
EXPOSE 8303/udp
ENTRYPOINT ["./teeworlds_srv"]
