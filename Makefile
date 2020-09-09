REGISTRY=gnomon
REPO=security-employee-tracker
SRC="https://github.com/scci/security-employee-tracker.git"
DATE=`date +%s`

build: clone
	docker build -t ${REGISTRY}/${REPO}:${DATE} . 2>&1 | tee /tmp/${REPO}.build.out

clone:
	for f in ${SRC}; do git clone ${f} 2>&1; done | tee /tmp/${REPO}.clone.out

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
