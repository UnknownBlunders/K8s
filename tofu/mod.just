set quiet
set shell := ['bash', '-euo', 'pipefail', '-c']

scripts_dir := justfile_dir() + '/scripts'
tf_dir := justfile_dir() + '/tofu'
called_dir := invocation_directory()

export MIKROTIK_DEVICE := file_name(invocation_directory())

[private]
default:
    just -l tf

[doc('Format recursively')]
fmt:
    tofu fmt -recursive {{ called_dir }}

init:
    op run --env-file={{ tf_dir }}/.env -- tofu -chdir={{ called_dir }} init

[doc('plan fast! Dont bother locking')]
pf:
    op run --env-file={{ tf_dir }}/.env -- tofu -chdir={{ called_dir }} plan -lock=false

[doc('plan out. Lock the state, format, validate, export the plan')]
po: fmt
    op run --env-file={{ tf_dir }}/.env -- tofu -chdir={{ called_dir }} validate
    op run --env-file={{ tf_dir }}/.env -- tofu -chdir={{ called_dir }} plan -out=out.plan

[doc('Apply the plan')]
ap:
    op run --env-file={{ tf_dir }}/.env -- tofu -chdir={{ called_dir }} apply out.plan
    rm {{ called_dir }}/out.plan
