require 'formula'

class Winetricks <Formula
  version 'head'
  # Alternative: http://winezeug.googlecode.com/svn/trunk/winetricks (However,
  # brew tries to do a svn checkout on the file and fails as svn checkout
  # expects a directory.)
  url 'http://winezeug.googlecode.com/svn/trunk/winetricks'
  homepage 'http://www.kegel.com/wine/winetricks'
  md5 'c849459ad55fa0da933696f1132eb85f'

  def install
    bin.install "winetricks"
  end
end
