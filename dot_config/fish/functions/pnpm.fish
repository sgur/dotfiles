function pnpm
    type --no-function --query pnpm || return 1
    type --no-function --query sfw || command pnpm add --global sfw
    type --no-function --query sfw || return 1

    set -l sub_commands add i install up update
    if test (count $argv) -ge 1; and contains "$argv[1]" $sub_commands
        command sfw pnpm $argv
    else
        command pnpm $argv
    end
end
