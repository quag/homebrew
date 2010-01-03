require 'formula'

class Soundtouch <Formula
  url 'http://www.surina.net/soundtouch/soundtouch-1.5.0.tar.gz'
  homepage 'http://www.surina.net/soundtouch/'
  md5 '5456481d8707d2a2c27466ea64a099cb'

  def patches
    DATA
  end

  def install
    # 64bit causes soundstretch to segfault when ever it is run.
    ENV.m32

    # The build fails complaining about out of date libtools. Rerunning the autoconf prevents the error.
    system "autoconf"

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

__END__
SoundTouch has a small amount of inline assembly. The assembly has two labeled
jumps. When compiling with gcc optimizations the inline assembly is duplicated
and the symbol label occurs twice causing the build to fail.

To get the build to succeed, instead of using a symbol name, forward labels are
used.

diff --git a/source/SoundTouch/cpu_detect_x86_gcc.cpp b/source/SoundTouch/cpu_detect_x86_gcc.cpp
index b0d0a69..9114476 100644
--- a/source/SoundTouch/cpu_detect_x86_gcc.cpp
+++ b/source/SoundTouch/cpu_detect_x86_gcc.cpp
@@ -92,37 +92,37 @@ uint detectCPUextensions(void)
         "\n\tpopf"                       // pop stack to restore esp
         "\n\txor     %%edx, %%edx"       // clear edx for defaulting no mmx
         "\n\tcmp     %%ecx, %%eax"       // compare to original eflags values
-        "\n\tjz      end"                // jumps to 'end' if cpuid not present
+        "\n\tjz      1f"                // jumps to 'end' if cpuid not present
         // cpuid instruction available, test for presence of mmx instructions
 
         "\n\tmovl    $1, %%eax"
         "\n\tcpuid"
         "\n\ttest    $0x00800000, %%edx"
-        "\n\tjz      end"                // branch if MMX not available
+        "\n\tjz      1f"                // branch if MMX not available
 
         "\n\tor      $0x01, %%esi"       // otherwise add MMX support bit
 
         "\n\ttest    $0x02000000, %%edx"
-        "\n\tjz      test3DNow"          // branch if SSE not available
+        "\n\tjz      0f"          // branch if SSE not available
 
         "\n\tor      $0x08, %%esi"       // otherwise add SSE support bit
 
-    "\n\ttest3DNow:"
+    "\n\t0:"
         // test for precense of AMD extensions
         "\n\tmov     $0x80000000, %%eax"
         "\n\tcpuid"
         "\n\tcmp     $0x80000000, %%eax"
-        "\n\tjbe     end"                 // branch if no AMD extensions detected
+        "\n\tjbe     1f"                 // branch if no AMD extensions detected
 
         // test for precense of 3DNow! extension
         "\n\tmov     $0x80000001, %%eax"
         "\n\tcpuid"
         "\n\ttest    $0x80000000, %%edx"
-        "\n\tjz      end"                  // branch if 3DNow! not detected
+        "\n\tjz      1f"                  // branch if 3DNow! not detected
 
         "\n\tor      $0x02, %%esi"         // otherwise add 3DNow support bit
 
-    "\n\tend:"
+    "\n\t1:"
 
         "\n\tmov     %%esi, %0"
 
