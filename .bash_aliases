# typo
alias claer='clear'
alias ckear='clear'

# ffmpeg
alias ffmpeg='ffmpeg -hide_banner'
alias ffplay='ffplay -hide_banner'
alias ffprobe='ffprobe -hide_banner'

# it's obvious
alias yt-dlp='yt-dlp --cookies-from-browser $BROWSER'

# make proxychains quiet
alias proxychains='proxychains -q'

# proxy stuff
# downloader CLIs
alias pyt-dlp='proxychains yt-dlp --cookies-from-browser $BROWSER'
# LLM CLIs
alias psgpt='proxychains sgpt'
alias pgemini='proxychains gemini'
