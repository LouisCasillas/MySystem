# medium compression
ffmpeg -y -i "cartoon.mkv" -map 0:0 -filter:v "hqdn3d=4:4:3:3" -c:v libx265 -preset slow -tune animation -crf 28 -x265-params qcomp=0.8:bframes=8:ref=6:aq-mode=3:psy-rd=1:psy-rdoq=1:constrained-intra=1 -map 0:2 -c:a mp3 -b:a 128k -map 0:3 -c:s copy "new-cartoon.mkv" && mv "new-cartoon.mkv" "cartoon.mkv"

# extra compression, increases vibrancy of color
ffmpeg -y -i "cartoon.mkv" -vf "scale=960x540,hqdn3d=12:12:9:9,eq=saturation=1.1" -c:v libx265 -preset slow -crf 30 -x265-params qcomp=0.8:bframes=8:ref=6:aq-mode=3:psy-rd=1:psy-rdoq=1:constrained-intra=1 -c:a mp3 -b:a 128k -c:s copy "tmp/cartoon.mkv"

# removing logo
ffmpeg -y -i "movie.avi" -vf "delogo=x=54:y=35:w=128:h=48,hqdn3d=4:4:3:3,eq=saturation=1.1" -c:v libx265 -preset slow -crf 28 -x265-params qcomp=0.8:bframes=8:ref=6:aq-mode=3:psy-rd=1:psy-rdoq=1:constrained-intra=1 -c:a copy -c:s copy "tmp/movie.mkv"

#add srt to video without re-encoding
ffmpeg -i video.mkv -i subtitle.srt -c:v copy -c:a copy -c:s srt video-with-subtitle.mkv
