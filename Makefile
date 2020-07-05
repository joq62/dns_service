all:
	rm -rf app_config catalog node_config  logfiles *_service include *~ */*~ */*/*~;
	rm -rf *.beam erl_crash.dump */erl_crash.dump */*/erl_crash.dump;
#	include
	git clone https://github.com/joq62/include.git;
	cp src/*.app ebin;
	erlc -I include -o ebin src/*.erl;
	rm -rf include;
doc_gen:
	rm -rf  node_config logfiles doc/*;
	erlc ../doc_gen.erl;
	erl -s doc_gen start -sname doc

test:
	rm -rf  include logfiles latest.log node_config catalog *_service;
	rm -rf *.beam ebin/* test_ebin/* erl_crash.dump;
#	include
	git clone https://github.com/joq62/include.git;
#	node_config
	git clone https://github.com/joq62/node_config.git;
#	catalog
#	git clone https://github.com/joq62/catalog.git;
	cp src/*app ebin;
	erlc -I include -o ebin src/*.erl;
	erlc -o test_ebin test_src/*.erl;
	erl -pa ebin -pa test_ebin -s dns_service_tests start -sname dns_test
