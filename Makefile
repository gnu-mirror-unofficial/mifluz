ECHO=
CVSROOT = mifluz
PRODUCT = mifluz

all: co dist doc tag clean

co:
	cvs -d subversions.gnu.org:/cvsroot/$(CVSROOT) co $(PRODUCT)

dist:
	cd $(PRODUCT) ; ./configure --enable-maintainer-mode ; make distcheck
	cp -p $(PRODUCT)/*.tar.gz ftp

tag:
	ver=`sed -e 's/^\([0-9][0-9]*\)\.\([0-9][0-9]*\).*/\1-\2/' < $(PRODUCT)/.version` ; \
	cd $(PRODUCT) ; $(ECHO) cvs tag $(PRODUCT)-$$ver

doc:
	-tidy -asxml -q $(PRODUCT)/doc/$(PRODUCT).html > doc/mifluz.html
	perl -pi -e '$$_ = "" if((/<!DOCTYPE/ .. /<body/) || (/body>/ .. /html>/))' doc/$(PRODUCT).html

upload:
	cd ftp ; rsync --exclude-from=exclude --rsh=ssh -av *.tar.gz gnuftp.gnu.org:/home/ftp/gnu/mifluz/

clean:
	rm -fr $(PRODUCT)

.PHONY: doc
