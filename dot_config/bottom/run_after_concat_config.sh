#!/bin/sh

cat << _HEADER_ > bottom.toml
# Concat default config with theme config
#

_HEADER_

cat default_config.toml >> bottom.toml

cat themes/mocha.toml >> bottom.toml
