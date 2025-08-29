#/bin/bash

# default values
python_version="3.13"
python_arch="x86_64"

# Parse command line options
TEMP=$(getopt -o v:a:h --long python-version:,python-arch:,help -n 'build_package.sh' -- "$@")

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

while true ; do
    case "$1" in
        -v|--python-version)
            python_version="$2" ; shift 2 ;;
        -a|--python-arch)
            python_arch="$2" ; shift 2 ;;
        -h|--help)
            echo "Usage: $0 [--python-version VERSION] [--python-arch ARCH]"
            echo "  --python-version: Python version (default: 3.13)"
            echo "  --python-arch: Python architecture (default: x86_64)"
            exit 0 ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

# define targets and remove if already exist
python_platform="${python_arch}-manylinux_2_34"
pyversion="$(echo py${python_version} | tr -d '.')"
target_file_name="awslambda_package-${python_arch}-${pyversion}.zip"

target_file="${PWD}/${target_file_name}"
lock_file=".requirements.lock"
tmp_dir=".lambda_tmp"
rm -fr ${target_file} ${tmp_dir} ${lock_file}

# install to tmp_dir
uv export --no-dev --no-emit-project --frozen --all-extras > ${lock_file}
uv pip install --python-platform ${python_platform} --python-version ${python_version} --target ${tmp_dir} --only-binary :all: -r ${lock_file}
uv pip install --python-platform ${python_platform} --python-version ${python_version} --target ${tmp_dir} .
rm -rf ${tmp_dir}/bin
cp run.sh ${tmp_dir}

# create zip package
lzpb ${tmp_dir} ${target_file}

# clean up
rm -fr ${tmp_dir} ${lock_file}