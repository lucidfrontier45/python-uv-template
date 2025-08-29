# Usage: build_awslambda_package.nu [--python-version <version>] [--python-arch <arch>] [--help]

def main [
    --python-version: string = "3.13"
    --python-arch: string = "x86_64"
    --help
] {
    if $help {
        print "Usage: build_package.nu [--python-version <version>] [--python-arch <arch>]"
        print "Python Version: default=3.13"
        print "Python Architecture: default=x86_64, options=x86_64 or aarch64"
        return
    }

    # define targets and remove if already exist
    let python_platform = $"($python_arch)-manylinux_2_34"
    let pyversion = $"py($python_version | str replace '.' '')"
    let target_file_name = $"awslambda_package-($python_arch)-($pyversion).zip"
    let target_file =  [$env.PWD, $target_file_name] | path join
    let lock_file = ".requirements.lock"
    let tmp_dir = ".lambda_build_tmp"
    rm -rf $target_file $tmp_dir $lock_file

    # Install dependencies to lambda_package directory
    uv export --no-dev --no-emit-project --frozen --all-extras | save -f $lock_file
    uv pip install --python-version $python_version --python-platform $python_platform --target $tmp_dir --only-binary :all: -r $lock_file
    uv pip install --python-version $python_version --python-platform $python_platform --target $tmp_dir .
    rm -rf ($tmp_dir | path join "bin")
    cp run.sh $tmp_dir

    # Create zip
    lzpb $tmp_dir $target_file

    # Clean up
    rm -rf $tmp_dir $lock_file
}