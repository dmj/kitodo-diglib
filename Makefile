.PHONY: test
test:
	xspec.cmd -s test/schema/diglib.xspec
	xspec.cmd test/xslt/mets.xspec
