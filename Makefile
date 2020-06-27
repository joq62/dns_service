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
	rm -rf  logfiles latest.log  *_service;
	rm -rf *.beam ebin/* test_ebin/* erl_crash.dump;
	cp src/*app ebin;
	erlc -o ebin src/*.erl;
	erlc -o test_ebin test_src/*.erl;
	erl -pa ebin -pa test_ebin -s dns_service_tests start -sname dns_test
