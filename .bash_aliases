# typo
alias claer='clear'
alias ckear='clear'

# ffmpeg
alias ffmpeg='ffmpeg -hide_banner'
alias ffplay='ffplay -hide_banner'
alias ffprobe='ffprobe -hide_banner'

# make proxychains quiet
alias proxychains='proxychains -q'

# download w/ file name
alias wget='wget --content-disposition'

# downloader CLIs
alias yt-dlp='yt-dlp --cookies-from-browser $BROWSER --js-runtimes node --remote-components ejs:github -R infinite --fragment-retries infinite --extractor-retries infinite --continue'
alias pyt-dlp='proxychains yt-dlp --cookies-from-browser $BROWSER --js-runtimes node --remote-components ejs:github -R infinite --fragment-retries infinite --extractor-retries infinite --continue'

# LLM CLIs
alias psgpt='proxychains sgpt'
alias pgemini='proxychains gemini'
alias pcodex='proxychains codex'

alias claude="TZ=Asia/Istanbul claude --allow-dangerously-skip-permissions"
alias grok="TZ=Asia/Istanbul grok"

# ssh
alias ssh='ssh -o Compression=yes'
alias autossh='autossh -o Compression=yes'
