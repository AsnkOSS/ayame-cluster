venv_home_dir := join(justfile_directory(), ".venv")
export UV_PROJECT_ENVIRONMENT := venv_home_dir

uv-venv:
    uv venv

uv-install:
    uv pip install -r kubespray/requirements.txt
    uv pip freeze > uv.lock
    uv pip sync uv.lock

uv-sync:
    uv pip sync uv.lock
