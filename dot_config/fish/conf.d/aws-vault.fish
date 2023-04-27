if type -q aws-vault
    set -gx AWS_VAULT_BACKEND pass
    set -gx AWS_VAULT_PASS_CMD gopass
    set -gx AWS_VAULT_PASS_PREFIX aws-vault
end
