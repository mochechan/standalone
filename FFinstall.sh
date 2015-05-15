#!/bin/bash
# tested: ubuntu 14.04 
echo It is going to install ffmpeg with all functions.
echo http://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu
sudo apt-get install autoremove

sudo apt-get update
sudo apt-get -y install autoconf automake build-essential libass-dev libfreetype6-dev libgpac-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libx11-dev libxext-dev libxfixes-dev pkg-config texi2html zlib1g-dev libmp3lame-dev libopus-dev 

sudo apt-get -y install libass-dev libass4 libtheora0 libtheora-dev libvorbis-dev libvorbis0a libvorbisenc2 libvorbisfile3 libx264-dev libxext6 libxext-dev libxfixes3 libxfixes-dev # old ubuntu 12.04 版需要這麼麻煩 

sudo apt-get -y install yasm nasm unzip 

rm -Rf /tmp/ffmpeg_sources
mkdir -v /tmp/ffmpeg_sources
cd /tmp/ffmpeg_sources

wget http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
tar xjf last_x264.tar.bz2
cd x264-snapshot*
PATH="$PATH:$HOME/bin" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --disable-opencl
PATH="$PATH:$HOME/bin" make
make install
make distclean
cd - 

wget -O fdk-aac.zip https://github.com/mstorsjo/fdk-aac/zipball/master
unzip -q fdk-aac.zip
cd mstorsjo-fdk-aac*
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean
cd -

wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="$HOME/ffmpeg_build" --enable-nasm --disable-shared
make
make install
make distclean
cd -

wget http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz
tar xzf opus-1.1.tar.gz
cd opus-1.1
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean
cd -

wget http://webm.googlecode.com/files/libvpx-v1.3.0.tar.bz2
tar xjf libvpx-v1.3.0.tar.bz2
cd libvpx-v1.3.0
./configure --prefix="$HOME/ffmpeg_build" --disable-examples
make
make install
make clean
cd -

wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$PATH:$HOME/bin" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-nonfree \
  --enable-x11grab \
  --enable-libfontconfig \
  --enable-libfribidi
PATH="$PATH:$HOME/bin" make
make install
make distclean
hash -r
cd -

