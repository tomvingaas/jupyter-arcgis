From ubuntu:latest

#ubuntu
RUN apt-get update && yes|apt-get upgrade
RUN apt-get install -y emacs
RUN apt-get install -y wget bzip2
RUN apt-get -y install sudo

#python pg pip
RUN apt-get install -y build-essential python3.6 python3-pip python3-dev
RUN pip3 -q install pip --upgrade
RUN pip3 -q install pip --upgrade

#setter hvor jupyter og annet skal installeres
RUN mkdir src
WORKDIR src/
COPY . .

# installer bibliotek som er definert i requirements.txt og jupyter
RUN pip3 install -r requirements.txt
RUN pip3 install jupyter

#sett hvor notebooks'ene skal lagres i containeren
WORKDIR /src/notebooks

#forhindrer at containeren krasjer
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]






