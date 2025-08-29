Param(
    [String]$PythonVersion = "3.13",
    [String]$PythonArch = "x86_64",
    [switch]$h
)

# show help if -h is passed
if ($h) {
    Write-Host "Usage: build_package.ps1 [-PythonVersion <version>] [-PythonArch <arch>]"
    Write-Host "Python Version: default=3.13"
    Write-Host "Python Architecture: default=x86_64, options=x86_64 or aarch64"
    exit
}

# define targets and remove if already exist
$pythonPlatform = "$($PythonArch)-manylinux_2_34"
$pyVersion = "py" + $PythonVersion.Replace(".", "")
$targetFileName = "awslambda_package-$($PythonArch)-$($pyVersion).zip"
$targetFile = Join-Path -Path $PWD -ChildPath $targetFileName
$lockFile = ".requirements.lock"
$tmpDir = ".lambda_build_tmp"

if (Test-Path -Path $tmpDir) {
    Remove-Item -Path $tmpDir -Recurse -Force
}

if (Test-Path -Path $targetFileName) {
    Remove-Item -Path $targetFileName -Force
}

# install dependencies to lambda_package directory
uv export --no-dev --no-emit-project --frozen --all-extras > $lockFile
uv pip install --python-version $PythonVersion --python-platform $pythonPlatform --target $tmpDir --only-binary :all: -r $lockFile
uv pip install --python-version $PythonVersion --python-platform $pythonPlatform --target $tmpDir .
Remove-Item -Recurse -Force -Path (Join-Path -Path $tmpDir -ChildPath "bin")
Copy-Item -Path run.sh -Destination $tmpDir

# create lambda_package.zip
lzpb $tmpDir $targetFile

# clean up
Remove-Item -Recurse -Force -Path @($tmpDir, $lockFile)