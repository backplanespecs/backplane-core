XML=backplane.xml backplane-identity-scenario.xml backplane-activitystreams-scenario.xml
TXT=${XML:.xml=.txt}
HTML=${XML:.xml=.html}
PDF=${XML:.xml=.pdf}

XML2RFC=./lib/xml2rfc.tcl
TCLSH=tclsh8.4
FOP=fop
XSLTPROC=xsltproc
XMLLINT=xmllint

all: prepare ${TXT} ${HTML} ${PDF}

.PHONY:: clean
clean::
	rm -rf build/*.html build/*.txt build/*.pdf

.PHONY:: prepare
prepare::
	mkdir -p build

.PHONY:: check
check::
	@${XMLLINT} --valid --noout ${XML} && echo "OK"

.SUFFIXES:.xml .html .txt .pdf
.xml.txt:
	${TCLSH} ${XML2RFC} xml2rfc $< build/$@

.xml.html:
	${TCLSH} ${XML2RFC} xml2rfc $< build/$@

.xml.pdf:
	${XSLTPROC} lib/xslt/rfc2629toFO.xslt $< | grep -v '<!DOCTYPE' > build/tmp.fo
	${XSLTPROC} lib/xslt/xsl11toFop.xslt build/tmp.fo > build/tmp-ext.fo
	${FOP} build/tmp-ext.fo build/$@
	rm -f build/tmp.fo build/tmp-ext.fo
