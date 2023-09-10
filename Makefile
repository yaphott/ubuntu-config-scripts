cold:
	cd vagrant_base
	bash prepare_box.sh
	cd ..
	
	cd vagrant_main
	bash run_box.sh
	cd ..

warm:
	cd vagrant_main
	bash run_box.sh
	cd ..
