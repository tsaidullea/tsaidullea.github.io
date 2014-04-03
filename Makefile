BUILD ?= /tmp/BUILD.huilehua
DEST ?= huilehua:/home/public

default: deploy-main

clean:
	rm -fr $(BUILD)

$(BUILD):
	mkdir -p $(BUILD)

.PHONY: $(BUILD)/RSYNC_FILES.txt
$(BUILD)/RSYNC_FILES.txt: $(BUILD)
	rm -f $@
	touch $@
	find -E . -iregex '.*\.(css|html|jpg|ico|png)' >>$@
	find . -name .htaccess >>$@
	echo robots.txt >>$@

stage: $(BUILD)/RSYNC_FILES.txt
	rm -fr $(BUILD)/stage
	rsync -avP ./ --delete --files-from=$< $(BUILD)/stage/
	export HTMLS=$$(find $(BUILD)/stage -name \*.html); echo $$HTMLS |xargs -n 1 sed -i .BAK 's|img src="\(../\)*graphics/|img src="http://huilehua1.appspot.com/graphics/|g' && for fn in $$HTMLS; do touch -r $$fn.BAK $$fn && rm $$fn.BAK; done

.PHONY: deploy-media deploy-main deploy-all
deploy-media:
	appcfg.py --oauth2 update .

deploy-main: stage
	rsync -avP --delete --exclude \*.BAK $(BUILD)/stage/ $(DEST)/

deploy-all: deploy-media deploy-main
