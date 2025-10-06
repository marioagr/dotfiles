alias cat='batcat'

alias artisan='php artisan'
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'

alias sund='sail up -d && sail npm run dev'
alias supd='sail up -d && sail pnpm run dev'

# NPM
alias nrd='npm run dev'
alias nrb='npm run build'
# PNPM
alias prd='pnpm run dev'
alias prb='pnpm run build'

alias lzg='lazygit'

alias lzd='lazydocker'

alias doc="docker-compose"

