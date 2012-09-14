Ubuntu 12.04
============

For Development
---------------

$ git clone https://github.com/friendlycode/viget-lw.git
$ cd viget-lw
$ make install_system_packages 
Fix missing symlinks on 64bit Ubuntu:
    ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib
    ln -s /usr/lib/x86_64-linux-gnu/libfreetype.so /usr/lib
    ln -s /usr/lib/x86_64-linux-gnu/libz.so /usr/lib
$ make install_dev
$ make setup_dev
$ make run_server_dev
$ ^C
$ make stop_solr


Working on the mediawiki importer?
----------------------------------

Follow for Development instructions, then:
Modify requirements_importers.txt to point to your localwiki_importers repo or dev instance on your machine
$ make install_importers
$ make run_importers

On subsequent runs:
$ make reset_dev
$ make install_importers
$ make run_importers

To keep the solr spam out of your main run screen:
Open another terminal at viget-lw
$ make start_solr
Switch to main terminal
$ make run_importers


Notes:
------

Solr runs on port 8080. You can access the admin at http://localhost:8080/solr/admin/
To shut down solr: `make stop_solr`

