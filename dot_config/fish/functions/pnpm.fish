function pnpm
    type --no-function --query pnpm || return 1
    type --no-function --query sfw || command pnpm add --global sfw

    set -l sub_commands add i install up update
    if type --no-function --query sfw; and test (count $argv) -ge 1; and contains "$argv[1]" $sub_commands
        command sfw pnpm $argv
    else
        command pnpm $argv
    end
end
