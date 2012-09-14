# Viget-lw is an easy way to get started developing on the viget.org localwiki.
It is designed for Ubuntu 12.04, but should also work on 10.04 without many 
changes. The idea is to make the installation and setup of a localwiki 
development environment easy and repeatable.

Notable changes from the localwiki dev install docs are:  

+ Uses a user-installed and controllable solr instance instead of a system service  
+ All install, setup, and clean (teardown) commands are available via make

Some things to be aware of:  

 * Sometimes solr does not shut down after `make reset_dev`. You can manually shut it down with `make stop_solr` afterwards.
 * The postgis_template table in Postgres is installed with the postgresql-9.1-postgis package and cannot be deleted. You may see an error about this when using `make reset_localwiki` but it shouldn't be a problem.


