The vidz collection requires the free, open-source program ffmpeg.

These instructions are for Mac OS.

- - - gcc

Installing ffmpeg requres a free compiler, gcc

Open a terminal window (Applications > Utilities > Terminal)
type gcc and hit ENTER
if you see 'gcc not found', you need to install a c compiler. on mac, this is the xcode developer tools.
google "download xcode" and follow the links. you will have to create a mac developer profile in order to download
in the downloads section, click "Developer Tools" in the list on the right
	for snow leopard, use xcode 3.2.3
	for leopard, use xcode 3.1.4

you can either install all of xcode, or just the gcc. to do just gcc, find the Packages directory after uncompressing the archive and run the gcc4.2.pkg.

- - - ffmpeg

The following is based on http://stephenjungels.com/jungels.net/articles/ffmpeg-howto.html
Do: "Building FFmpeg for Mac OS X Leopard"
(note: the instructions here recommend downloading source code to ~/ffmpeg. I downloaded source code to /usr/local/src/ffmpeg. Either way, it installs to /usr/local/bin and after that you can delete the source code folder)

mkdir ~/ffmpeg
cd ~/ffmpeg
svn checkout svn://svn.ffmpeg.org/ffmpeg/trunk
./configure --enable-shared --disable-mmx --arch=x86_64 --enable-avfilter
make
sudo make install
