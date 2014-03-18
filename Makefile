BUILD ?= ../BUILD
HTMLS ?= $(shell find . -name \*.html)

default: rewrite-links deploy

rewrite-links:
	echo $(HTMLS) |xargs -n 1 sed -i .BAK 's|img src="\(../\)*graphics/|img src="http://huilehua1.appspot.com/graphics/|g'

clean:
	git checkout -- $(HTMLS)
	rm -fr $(BUILD)


DEST ?= $(BUILD)
#DEST ?= server:/doc/root

.PHONY: RSYNC_FILES.txt
RSYNC_FILES.txt:
	find -E . -iregex '.*\.(css|html|jpg|png)' >$@

deploy: RSYNC_FILES.txt
	rsync -avP ./ --delete --files-from=$< $(DEST)/
