# compile the meshlite package
# change: remove the commands to activate virtualenv (assuming user has already activated before calling `make`)
# tianye

tmpdirbuild := temporary_test
venv_dir := $(tmpdirbuild)/venv
activate := $(venv_dir)/bin/activate
package_name := psbody_meshlite

.DEFAULT_GOAL := all

$(tmpdirbuild):
	mkdir -p $(tmpdirbuild)

$(tmpdirbuild)/package_creation: $(tmpdirbuild)
	@echo "********" $(package_name) ": Installing dependencies"
	@pip install --upgrade pip virtualenv setuptools wheel
	@pip install numpy scipy pyopengl pyzmq

	@echo "******** [" ${package_name} "] Creating the source distribution"
	@python setup.py sdist

	@echo "******** [" ${package_name} "] Creating the wheel distribution"
	@python setup.py --verbose bdist_wheel

	####### Cleaning some artifacts
	@rm -rf psbody_meshlite.egg-info
	####### Touching the result
	@touch $@

all: $(tmpdirbuild)/package_creation

install:
	@echo "********" $(package_name) ": installation"
	@echo "** installing " $(package_name) && cd dist && pip install --verbose --no-cache-dir *.whl ;

clean:
	@rm -rf $(tmpdirbuild)
	@find . -name "*.pyc" -delete
	@rm -rf build
	@rm -rf dist
	@rm -rf psbody_meshlite.egg-info
