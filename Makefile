install:
	bash ./run.sh

test-cold:
	@$(MAKE) clean
	@echo 'Preparing base box...'
	@bash -e ./vagrant_base/prepare_box.sh
	@$(MAKE) test-warm

test-warm:
	@echo 'Running tests...'
	bash -e ./vagrant_main/run_box.sh

clean:
	@$(MAKE) clean-main
	@$(MAKE) clean-base

clean-main:
	@echo "Cleaning up main..."
	@cd vagrant_main && (\. ./_exports.sh && vagrant destroy -f 2>/dev/null)
	@rm -f ./vagrant_main/ubuntu-*-console.log

clean-base:
	@echo "Cleaning up base..."
	@cd vagrant_base && (\. ./_exports.sh && vagrant destroy -f 2>/dev/null) && (vagrant box remove -f ucs-base 2>/dev/null || true)
	@rm -f ./vagrant_base/ubuntu-*-console.log
