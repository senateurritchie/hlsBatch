:: Ceci est mon programme ffmpeg pour generer automatiquement
:: une playlist hls avec des bitrates differents

@echo off
setlocal enableDelayedExpansion
title FFMPEG HLS FOR VOD - Zacharie Assagou
color 1F
set duration=10

FOR %%i in (*.mp4) do (
	:: nous parcourons uniquement les fichiers
	set name=%%~ni
	set extention=%%~xi
	set dossier=%%~dpi

	set d_a_creer=!dossier!!name!
	set fichier=!name!!extention!

	if not exist "!d_a_creer!" (
		MKDIR "!d_a_creer!"
	)

	:: on execute FFMPEG pour creer une vignette
	ffmpeg -y -ss 10 -i "!fichier!" -vframes 1 -s 640x360 -q:v 2 "!d_a_creer!/poster.jpg"

	:: on execute FFMPEG pour generer le flux hls
	ffmpeg -hide_banner -y -i "!fichier!" -vf scale=w=640:h=360:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -g 48 -keyint_min 48 -hls_time %duration% -hls_playlist_type vod  -b:v 800k -maxrate 856k -bufsize 1200k -b:a 96k -hls_segment_filename "!d_a_creer!/360p_%%03d.ts" "!d_a_creer!/360p.m3u8" -vf scale=w=842:h=480:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -g 48 -keyint_min 48 -hls_time %duration% -hls_playlist_type vod -b:v 1400k -maxrate 1498k -bufsize 2100k -b:a 128k -hls_segment_filename "!d_a_creer!/480p_%%03d.ts" "!d_a_creer!/480p.m3u8" -vf scale=w=1280:h=720:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -g 48 -keyint_min 48 -hls_time %duration% -hls_playlist_type vod -b:v 2800k -maxrate 2996k -bufsize 4200k -b:a 128k -hls_segment_filename "!d_a_creer!/720p_%%03d.ts" "!d_a_creer!/720p.m3u8" -vf scale=w=1920:h=1080:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -g 48 -keyint_min 48 -hls_time %duration% -hls_playlist_type vod -b:v 5000k -maxrate 5350k -bufsize 7500k -b:a 192k -hls_segment_filename "!d_a_creer!/1080p_%%03d.ts" "!d_a_creer!/1080p.m3u8"

	MOVE "!filename!" "!d_a_creer!/!fichier!" 
)
