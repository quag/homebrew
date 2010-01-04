require 'formula'

class Pngnq <Formula
  url 'http://downloads.sourceforge.net/project/pngnq/pngnq/1.0/pngnq-1.0.tar.gz'
  homepage 'http://pngnq.sourceforge.net/'
  md5 '2d2cdacf0284477c662fee888c8092d5'

# depends_on 'cmake'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
#   system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
