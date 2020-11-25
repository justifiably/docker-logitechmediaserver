SH=/bin/bash
TAG=$(shell cat lmsdeb.txt | sed 's/.*_\([0-9\.~]*\)_all.deb/\1/' | sed 's/~/-/')
USER=justifiably
LMS_PATCHES=Y

build: 
	docker build --build-arg LMSDEB=`cat lmsdeb.txt` --build-arg LMS_PATCHES=$(LMS_PATCHES) -t $(USER)/logitechmediaserver:$(TAG) .; docker tag $(USER)/logitechmediaserver:$(TAG) $(USER)/logitechmediaserver:latest

base:
	wget -O - -q "http://www.mysqueezebox.com/update/?version=8.0.0&revision=1&geturl=1&os=deb" > lmsdeb.txt

# Grab 8.0.1 development release
update:
	-(LMSLATEST=`wget -O - -q "http://www.mysqueezebox.com/update/?version=8.0.1&revision=1&geturl=1&os=deb"`; if [ "`cat lmsdeb.txt`" = "$$LMSLATEST" ]; then echo "No update available"; exit 1; else /bin/echo -n $$LMSLATEST > lmsdeb.txt; fi)
