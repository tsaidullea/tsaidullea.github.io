BUILD ?= ../BUILD
DEST ?= huilehua:/home/public

default: deploy-main

clean:
	git checkout -- $(HTMLS)
	rm -fr $(BUILD)


.PHONY: RSYNC_FILES.txt
RSYNC_FILES.txt:
	find -E . -iregex '.*\.(css|html|jpg|ico|png)' >$@

stage: RSYNC_FILES.txt
	rm -fr $(BUILD)
	rsync -avP ./ --delete --files-from=$< $(BUILD)/
	echo $$(find $(BUILD) -name \*.html) |xargs -n 1 sed -i .BAK 's|img src="\(../\)*graphics/|img src="http://huilehua1.appspot.com/graphics/|g'

.PHONY: deploy-media deploy-main deploy-all
deploy-media:
	appcfg.py --oauth2 update .

deploy-main: stage
	rsync -avP --delete --exclude \*.BAK $(BUILD)/ $(DEST)/

deploy-all: deploy-media deploy-main
