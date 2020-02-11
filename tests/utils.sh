#!/usr/bin/env bash
set -exuo pipefail

install_conda() {
	CONDASH=`mktemp`
	curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh > $CONDASH
	bash $CONDASH -b -u -p /usr/local/miniconda
	export PATH=/usr/local/miniconda/bin/:$PATH
	conda update -y -n base -c defaults conda
}


ag_conda_environment_() {
	export PATH=/usr/local/miniconda/bin/:$PATH
	conda env update -n autogluon_py3 -f tests/conda_environment.yml
	# https://github.com/conda/conda/issues/7980
	eval "$(conda shell.bash hook)"
	conda activate autogluon_py3
	conda list
	pip install --upgrade --force-reinstall -e .
}


run_tests_docker() {
    docker build -t autogluon .
    PRJ_ROOT=`readlink -f ..`
    docker run -v $PRJ_ROOT:/autogluon/ -ti autogluon /work/utils.sh run_tests_conda_
}


run_tests_conda_() {
    ag_conda_environment_
    run_all
}

run_all() {
    ag_conda_environment_
    FILES=./tests/unittests/*.py
    for f in $FILES
    do
      echo "Evaluating $f file..."
      # take action on each file. $f store current file name
      python $f
    done
}


##############################################################
# MAIN
#
# Run function passed as argument
if [ $# -gt 0 ]
then
    $@
else
    cat<<EOF

$0: Execute a function by passing it as an argument to the script:

Possible commands:

EOF
    declare -F | cut -d' ' -f3
    echo
fi

