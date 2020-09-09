REGISTRY=gnomon
REPO=security-employee-tracker
SRCREPO=scci
SRC=security-employee-tracker
GITURL=https://github.com/${SRCREPO}/${SRC}.git
DATE=`date +%s`

build: clone
	docker build -t ${REGISTRY}/${REPO}:${DATE} . 2>&1 | tee /tmp/${REPO}.build.out

clone:
	if [ ! -d ${SRC} ]; then git clone ${GITURL}; else cd ${SRC}; git pull; fi

push:
	docker login
	docker push ${REGISTRY}/${REPO}:${DATE}

all: build push

clean:
	docker container prune --force
	docker image rmi `docker images -f "dangling=true" -q`

cleaner: clean
	docker image rmi --force `docker images -q`

cleanest: cleaner
	echo rm -rf security-employee-tracker phpenv
