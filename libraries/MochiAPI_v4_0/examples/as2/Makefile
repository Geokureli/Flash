OUTPUT=example.swf
SOURCES=*.as ui/*.as Makefile

all: $(OUTPUT)

clean:
	rm -f $(OUTPUT)

run: $(OUTPUT)
	open $(OUTPUT)

example.swf: $(SOURCES)
	mtasc -infer -version 7 -swf $@ -main -header 550:400:25:869CA7 Init.as
	LocalContentUpdater -a $@

.PHONY: all clean
