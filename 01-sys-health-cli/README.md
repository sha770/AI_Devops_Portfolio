# sys-health-cli

Simple Python CLI to show CPU, memory, and disk usage.

## Features
- --cpu: Show CPU %
- --mem: Show memory %
- --disk: Show disk %
- --all: Show all metrics

## How to Run
cd 01-sys-health-cli
venv\Scripts\activate
black .
falke8 .
## then test
$env:PYTHONPATH = (Get-Location).Path
python src/sys_health_cli.py --all

## Tests
python -m pytest -q