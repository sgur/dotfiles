if type -q aws-vault; and test -d ~/.password-store
    set -gx AWS_VAULT_BACKEND pass
    set -gx AWS_VAULT_PASS_PREFIX aws-vault

    set -gx AWS_VAULT_PASS_CMD pass
    if type -q gopass
        set -gx AWS_VAULT_PASS_CMD gopass
    end
end
