require 'formula'

class Vice < Formula
  homepage 'http://vice-emu.sourceforge.net/'

  #url 'http://downloads.sourceforge.net/project/vice-emu/development-releases/vice-2.4.25.tar.gz'
  #sha1 '1056da65c8598a268e23c715c1cae7457e06716b'
 
  # we checkout the svn repo because the release archive seems to be missing some files
  url 'svn://svn.code.sf.net/p/vice-emu/code/tags/v2.4/v2.4.25/vice'
  version '2.4.25'

  head 'http://svn.code.sf.net/p/vice-emu/code/trunk/vice'

  depends_on 'pkg-config' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'jpeg'
  depends_on 'libpng'
  depends_on 'giflib' => :optional
  depends_on 'lame' => :optional

  def install
    # Use Cocoa instead of X
    # Use a static lame, otherwise Vice is hard-coded to look in
    # /opt for the library.
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-cocoa",
                          "--without-x",
			  "--disable-nls",
                          "--enable-static-lame"#,
                          # VICE can't compile against FFMPEG newer than 0.11:
                          # http://sourceforge.net/tracker/?func=detail&aid=3585471&group_id=223021&atid=1057617
#                          "--disable-ffmpeg"
    system "make"
    system "make bindist"
    prefix.install Dir['vice-macosx-*/*']
    bin.install_symlink Dir[prefix/'tools/*']
  end

  def caveats
    "Cocoa apps for these emulators have been installed to #{prefix}."
  end
end
