install:
	bash ./run.sh

test-cold:
	bash ./vagrant_base/prepare_box.sh
	bash ./vagrant_main/run_box.sh

test-warm:
	bash ./vagrant_main/run_box.sh
