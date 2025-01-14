install:
	bash ./run.sh

test-cold:
	@$(MAKE) clean
	@echo 'Preparing base box...'
	@bash -e ./vagrant_base/prepare_box.sh
	@bash -e ./vagrant_main/run_box.sh
	@$(MAKE) test-warm

test-warm:
	@echo 'Running tests...'
	bash -e ./vagrant_main/run_box.sh

clean:
	@$(MAKE) clean-base
	@$(MAKE) clean-main

clean-base:
	@echo "Cleaning up base..."
	@cd vagrant_base && vagrant destroy -f &> /dev/null || true && vagrant box remove -f ucs-base &> /dev/null || true
	@rm -f ./vagrant_base/ubuntu-*-console.log
	@rm -rf ./vagrant_base/ubuntu-config-scripts

clean-main:
	@echo "Cleaning up main..."
	@cd vagrant_main && vagrant destroy -f &> /dev/null || true
	@rm -f ./vagrant_main/ubuntu-*-console.log
	@rm -rf ./vagrant_main/ubuntu-config-scripts
