test-cold:
	cd vagrant_base && bash prepare_box.sh
	cd vagrant_main && bash run_box.sh && vagrant up

test-warm:
	cd vagrant_main && bash run_box.sh && vagrant up
