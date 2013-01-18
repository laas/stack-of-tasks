INSTALL_DIRECTORY = /tmp
CMAKE = cmake .. -DCMAKE_INSTALL_PREFIX=$(INSTALL_DIRECTORY) -DCMAKE_BUILD_TYPE=release
DIR_LIST = \
	jrl-mathtools   \
	jrl-mal   \
	abstract-robot-dynamics   \
	jrl-dynamics   \
	hrp2_10   \
	hrp2_14   \
	hrp2-10-optimized   \
	hrp2Dynamics   \
	dynamic-graph   \
	dynamic-graph-python   \
	sot-core   \
	sot-dynamic   \
	sot-dyninv   \
	jrl-walkgen   \
	sot-pattern-generator   \
	robot-viewer

jrl-mathtools/build: jrl-mathtools/cmake/base.cmake
jrl-mal/build: jrl-mal/cmake/base.cmake
abstract-robot-dynamics/build: abstract-robot-dynamics/cmake/base.cmake
jrl-dynamics/build: jrl-dynamics/cmake/base.cmake
hrp2_10/build: hrp2_10/cmake/base.cmake
hrp2_14/build: hrp2_14/cmake/base.cmake
hrp2-10-optimized/build: hrp2-10-optimized/cmake/base.cmake
hrp2Dynamics/build: hrp2Dynamics/cmake/base.cmake
dynamic-graph/build: dynamic-graph/cmake/base.cmake
dynamic-graph-python/build: dynamic-graph-python/cmake/base.cmake
sot-core/build: sot-core/cmake/base.cmake
sot-dynamic/build: sot-dynamic/cmake/base.cmake
sot-dyninv/build: sot-dyninv/cmake/base.cmake
jrl-walkgen/build: jrl-walkgen/cmake/base.cmake
sot-pattern-generator/build: sot-pattern-generator/cmake/base.cmake

%/build:
	cd $(@:%/build=%); mkdir -p build
	cd $@; $(CMAKE)
	cd $@; make -s install

%-update: %/build
	cd $(@:%-update=%)/build; make -s install

# --->
# ---> Specialization
# --->

# ---> jrl mal
jrl-mal/build:
	cd $(@:%/build=%); mkdir -p build
	cd $@; $(CMAKE) -DSMALLMATRIX=jrl-mathtools
	cd $@; make -s install

%/cmake/base.cmake:
	cd $(@:%/cmake/base.cmake=%); git submodule init
	cd $(@:%/cmake/base.cmake=%); git submodule update

# ---> robot-viewer
robot-viewer/build:
	cd $(@:%/build=%); python setup.py install --prefix $(INSTALL_DIRECTORY)

robot-viewer-update:
	echo nothing to do

# --------------------------------
init: git-init dir-init

.PHONY: git-init
git-init:
	git submodule init
	git submodule update

.PHONY: dir-init
dir-init:  $(DIR_LIST:%=%/build)

# --------------------------------

update: git-update dir-update

git-update:
	git submodule update

dir-update:$(DIR_LIST:%=%-update)

%-compil:
	cd $(@:-dir=)/build; make -s install
