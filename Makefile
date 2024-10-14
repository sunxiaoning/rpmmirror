init:
	yum install epel-release yum-utils createrepo

default: build-mirrorall

build-mirror:
	./hack/build.sh mirror

# build the project
build-galera4:
	./hack/build.sh galera4

build-mirrorall:
	./hack/build.sh mirrorall

install-mirror: build-mirror
	./hack/install.sh mirror

# build the project
install-galera4: build-galera4
	./hack/install.sh galera4

install-mirrorall: build-mirrorall
	./hack/install.sh mirrorall