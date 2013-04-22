OUTPUT=MochiAd.swf
SOURCES=MochiFlex.mxml

all: $(OUTPUT)

clean:
	rm -f $(OUTPUT)

MochiAd.swf: $(SOURCES)
	mxmlc \
		-use-network \
		-optimize=true \
		-output $@ \
		MochiFlex.mxml

.PHONY: all clean
