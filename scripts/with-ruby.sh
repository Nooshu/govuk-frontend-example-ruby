#!/usr/bin/env bash
# Prefer Homebrew Ruby (with OpenSSL) over broken RVM builds that lack openssl.
set -euo pipefail

if [[ -x /opt/homebrew/opt/ruby/bin/ruby ]]; then
  export PATH="/opt/homebrew/lib/ruby/gems/3.3.0/bin:/opt/homebrew/opt/ruby/bin:${PATH}"
  export GEM_HOME="/opt/homebrew/lib/ruby/gems/3.3.0"
  export GEM_PATH="${GEM_HOME}"
elif [[ -x /usr/local/opt/ruby/bin/ruby ]]; then
  export PATH="/usr/local/lib/ruby/gems/3.3.0/bin:/usr/local/opt/ruby/bin:${PATH}"
  export GEM_HOME="/usr/local/lib/ruby/gems/3.3.0"
  export GEM_PATH="${GEM_HOME}"
fi

if ! ruby -ropenssl -e 'nil' >/dev/null 2>&1; then
  echo "error: Ruby cannot load OpenSSL." >&2
  echo "Install Homebrew Ruby (brew install ruby) or rebuild RVM Ruby with OpenSSL." >&2
  exit 1
fi

exec "$@"
