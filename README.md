# Assignment2-Dockerized-Diagnostic-CLI

A Bash diagnostic tool converted into a Dockerized application that can be built and run locally.

## Requirements

- Git
- Docker Engine with the Docker Compose plugin

## Setup

Clone the repository and enter its directory:

```bash
git clone https://github.com/sbr-sbr/Assignment2-Dockerized-Diagnostic-CLI.git
cd Assignment2-Dockerized-Diagnostic-CLI
```

The launcher can be used directly from the repository without installation:

```bash
./diagnostic help
```

## Install the command

To use `diagnostic` from any directory, create a symlink in your user-local bin directory:

```bash
mkdir -p "$HOME/.local/bin"
ln -sfn "$PWD/diagnostic" "$HOME/.local/bin/diagnostic"
export PATH="$HOME/.local/bin:$PATH"
```

Add the `export PATH` line to `~/.profile` or your shell startup file to keep it after opening a new terminal.

You can now run commands directly:

```bash
diagnostic system
diagnostic network google.com
diagnostic disk
diagnostic help
```

The launcher delegates to Docker Compose and builds the image when needed. The symlink should remain connected to the cloned repository because the launcher uses that directory as the Compose project directory.

## Test

Build the image and run the validation suite:

```bash
./grade.sh
```
