all:
	rm -rf app_config catalog node_config  logfiles *_service include *~ */*~ */*/*~;
	rm -rf *.beam erl_crash.dump */erl_crash.dump */*/erl_crash.dump;
	cp src/*.app ebin;
	erlc -o ebin src/*.erl;
doc_gen:
	rm -rf  node_config logfiles doc/*;
	erlc ../doc_gen.erl;
	erl -s doc_gen start -sname doc

test:
	rm -rf  logfiles latest.log node_config *_service;
	rm -rf *.beam ebin/* test_ebin/* erl_crash.dump;
#	node_config
	git clone https://github.com/joq62/node_config.git;
	cp src/*app ebin;
	erlc -o ebin src/*.erl;
	erlc -o test_ebin test_src/*.erl;
	erl -pa ebin -pa test_ebin -s dns_service_tests start -sname dns_test
