htmlfiles := $(patsubst data/%.md,html/%.html,$(wildcard data/*.md))
conffiles = conf/holidays.py conf/privates.py conf/config.py

all: $(htmlfiles) $(conffiles)

html/%.html: data/%.md
	pandoc $< -o $@

conf/%.py: data/%.md
	python3 buildconf.py $< $@
