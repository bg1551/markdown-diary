htmlfiles := $(patsubst static/data/%.md,static/html/%.html,$(wildcard static/data/*.md))
conffiles := static/conf/holidays.py static/conf/privates.py static/conf/config.py

all: $(htmlfiles) $(conffiles)

static/html/%.html: static/data/%.md
	pandoc $< -o $@

static/conf/%.py: static/data/%.md
	python buildconf.py $< $@
