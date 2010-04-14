RUBY19 = /usr/bin/ruby1.9.1
RUBY19LIBDIR = $(shell $(RUBY19) -rrbconfig -e "puts Config::CONFIG['rubylibdir']")

clean:
	rm -rf $(CURDIR)/deb/build
	rm -f $(CURDIR)/deb/rubygems1.9.1_1.3.6-1_i386.deb

all:
	$(RUBY19) setup.rb --no-rdoc --no-ri --prefix=$(CURDIR)/deb/build
	rm $(CURDIR)/deb/build/lib/rbconfig/datadir.rb
	mkdir -p $(CURDIR)/deb/build/$(RUBY19LIBDIR)
	mv $(CURDIR)/deb/build/lib/* $(CURDIR)/deb/build/$(RUBY19LIBDIR)
	mv $(CURDIR)/deb/build/bin $(CURDIR)/deb/build/usr
	rm -rf $(CURDIR)/deb/build/lib
	for file in `ls -1 deb/patches/*.patch`; do patch -p0 -i $$file; done
	cp -r $(CURDIR)/deb/DEBIAN/ $(CURDIR)/deb/build
	(cd $(CURDIR)/deb/build && md5sum `find ./usr -type f | awk '/.\// { print substr($$0, 3) }' ` > $(CURDIR)/deb/build/DEBIAN/md5sums)
	cp -r $(CURDIR)/deb/etc/ $(CURDIR)/deb/build
	mkdir -p $(CURDIR)/deb/build/usr/share/doc/rubygems1.9.1
	cat $(CURDIR)/ChangeLog | gzip > $(CURDIR)/deb/build/usr/share/doc/rubygems1.9.1/changelog.gz
	cp $(CURDIR)/deb/changelog.Debian.gz $(CURDIR)/deb/build/usr/share/doc/rubygems1.9.1
	cp $(CURDIR)/deb/copyright $(CURDIR)/deb/build/usr/share/doc/rubygems1.9.1
	cp $(CURDIR)/README $(CURDIR)/deb/build/usr/share/doc/rubygems1.9.1
	cp -r $(CURDIR)/deb/man/ $(CURDIR)/deb/build/usr/share
	(cd $(CURDIR)/deb && dpkg-deb -b build rubygems1.9.1_1.3.6-1_i386.deb)
