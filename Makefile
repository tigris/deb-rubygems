RUBY19 = /usr/bin/ruby1.9.1
RUBY19LIBDIR = $(shell $(RUBY19) -rrbconfig -e "puts Config::CONFIG['rubylibdir']")

RUBY18 = /usr/bin/ruby1.8
RUBY18LIBDIR = $(shell $(RUBY18) -rrbconfig -e "puts Config::CONFIG['rubylibdir']")

all: deb1.8 deb1.9

clean1.8:
	rm -rf $(CURDIR)/deb/build1.8
	rm -rf $(CURDIR)/deb/rubygems1.8_1.3.6-1_i386.deb

clean1.9:
	rm -rf $(CURDIR)/deb/build1.9.1
	rm -f $(CURDIR)/deb/rubygems1.9.1_1.3.6-1_i386.deb

clean: clean1.8 clean1.9

deb1.8: clean1.8
	$(RUBY18) setup.rb --no-rdoc --no-ri --prefix=$(CURDIR)/deb/build1.8
	rm $(CURDIR)/deb/build1.8/lib/rbconfig/datadir.rb
	mkdir -p $(CURDIR)/deb/build1.8/$(RUBY18LIBDIR)
	mv $(CURDIR)/deb/build1.8/lib/* $(CURDIR)/deb/build1.8/$(RUBY18LIBDIR)
	mv $(CURDIR)/deb/build1.8/bin $(CURDIR)/deb/build1.8/usr
	rm -rf $(CURDIR)/deb/build1.8/lib
	(cd deb/build1.8/$(RUBY18LIBDIR) && for file in `ls -1 $(CURDIR)/deb/patches/*.patch`; do patch -p0 -i $$file; done)
	cp -r $(CURDIR)/deb/DEBIAN-1.8/ $(CURDIR)/deb/build1.8/DEBIAN
	(cd $(CURDIR)/deb/build1.8 && md5sum `find ./usr -type f | awk '/.\// { print substr($$0, 3) }' ` > $(CURDIR)/deb/build1.8/DEBIAN/md5sums)
	mkdir -p $(CURDIR)/deb/build1.8/etc/bash_completion.d
	cp $(CURDIR)/deb/etc/bash_completion.d/gem1.8 $(CURDIR)/deb/build1.8/etc/bash_completion.d/gem1.8
	mkdir -p $(CURDIR)/deb/build1.8/usr/share/doc/rubygems1.8
	cat $(CURDIR)/ChangeLog | gzip > $(CURDIR)/deb/build1.8/usr/share/doc/rubygems1.8/changelog.gz
	cp $(CURDIR)/deb/changelog.Debian.gz $(CURDIR)/deb/copyright $(CURDIR)/README $(CURDIR)/deb/build1.8/usr/share/doc/rubygems1.8
	mkdir -p $(CURDIR)/deb/build1.8/usr/share/man/man1
	cp $(CURDIR)/deb/man/gem1.8.1.gz $(CURDIR)/deb/build1.8/usr/share/man/man1/gem1.8.1.gz
	(cd $(CURDIR)/deb && dpkg-deb -b build1.8 rubygems1.8_1.3.6-1_i386.deb)

deb1.9: clean1.9
	$(RUBY19) setup.rb --no-rdoc --no-ri --prefix=$(CURDIR)/deb/build1.9.1
	rm $(CURDIR)/deb/build1.9.1/lib/rbconfig/datadir.rb
	mkdir -p $(CURDIR)/deb/build1.9.1/$(RUBY19LIBDIR)
	mv $(CURDIR)/deb/build1.9.1/lib/* $(CURDIR)/deb/build1.9.1/$(RUBY19LIBDIR)
	mv $(CURDIR)/deb/build1.9.1/bin $(CURDIR)/deb/build1.9.1/usr
	rm -rf $(CURDIR)/deb/build1.9.1/lib
	(cd deb/build1.9.1/$(RUBY19LIBDIR) && for file in `ls -1 $(CURDIR)/deb/patches/*.patch`; do patch -p0 -i $$file; done)
	cp -r $(CURDIR)/deb/DEBIAN-1.9.1/ $(CURDIR)/deb/build1.9.1/DEBIAN
	(cd $(CURDIR)/deb/build1.9.1 && md5sum `find ./usr -type f | awk '/.\// { print substr($$0, 3) }' ` > $(CURDIR)/deb/build1.9.1/DEBIAN/md5sums)
	mkdir -p $(CURDIR)/deb/build1.9.1/etc/bash_completion.d
	cp $(CURDIR)/deb/etc/bash_completion.d/gem1.9.1 $(CURDIR)/deb/build1.9.1/etc/bash_completion.d/gem1.9.1
	mkdir -p $(CURDIR)/deb/build1.9.1/usr/share/doc/rubygems1.9.1
	cat $(CURDIR)/ChangeLog | gzip > $(CURDIR)/deb/build1.9.1/usr/share/doc/rubygems1.9.1/changelog.gz
	cp $(CURDIR)/deb/changelog.Debian.gz $(CURDIR)/deb/copyright $(CURDIR)/README $(CURDIR)/deb/build1.9.1/usr/share/doc/rubygems1.9.1
	mkdir -p $(CURDIR)/deb/build1.9.1/usr/share/man/man1
	cp $(CURDIR)/deb/man/gem1.9.1.1.gz $(CURDIR)/deb/build1.9.1/usr/share/man/man1/gem1.9.1.1.gz
	(cd $(CURDIR)/deb && dpkg-deb -b build1.9.1 rubygems1.9.1_1.3.6-1_i386.deb)
