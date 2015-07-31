FROM golang

ADD . /go/src/github.com/whobrokethebuild/stephenlw.com
WORKDIR /go/src/github.com/whobrokethebuild/stephenlw.com
RUN go get
RUN bash make.sh install

WORKDIR /go/bin
ENTRYPOINT /go/bin/stephenlw.com

EXPOSE 8080