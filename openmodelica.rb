require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Openmodelica < Formula
  homepage 'https://www.openmodelica.org'
  url 'file:///Users/tgu/Documents/om.tar.gz'
  sha1 'ddb0b3752e7aba2bd55d36b4646eef4af9aec7c0'
  head 'https://openmodelica.org/svn/OpenModelica/tags/OPENMODELICA_1_9_0_BETA', :using => :svn
  version '1'

  # depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'qwt'
  depends_on 'rml-mmc'
  depends_on 'lp_solve'
  depends_on :autoconf
  depends_on 'dbus'
  depends_on 'sundials'
  depends_on 'open-scene-graph'

  def patches
    DATA
  end

  def install
    ENV.j1  # if your formula's build system can't parallelize
    
    lps = Formula.factory 'lp_solve'
    qwt = Formula.factory 'qwt'

    system "autoconf"
    system "./configure", "--without-omniORB",
                          "--without-paradiseo",
                          "--prefix=#{prefix}",
                          "--with-qwt=#{include}"
    # system "cmake", ".", *std_cmake_args
    system "make"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test openmodelica`.
    system "false"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 7cde1a2..a982d37 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -68,7 +68,7 @@ omoptimbasis: mkbuilddirs
  $(MAKE) -C OMOptimBasis/build -f Makefile.unix
 endif
 
-qtclients: @OMNOTEBOOK@ omshell omedit omplot omoptim omoptimbasis
+qtclients: @OMNOTEBOOK@ omshell omedit omplot # omoptim omoptimbasis
 
 qtclean: qtclean-common
  $(MAKE) -C OMShell/OMShellGUI -f Makefile.unix clean
diff --git a/OMNotebook/OMNotebookGUI/OMNotebook.config.in b/OMNotebook/OMNotebookGUI/OMNotebook.config.in
index 3a5dee3..ca0e1ef 100644
--- a/OMNotebook/OMNotebookGUI/OMNotebook.config.in
+++ b/OMNotebook/OMNotebookGUI/OMNotebook.config.in
@@ -6,7 +6,11 @@ CORBALIBS = @CORBALIBS@
 CORBAINC = @CORBA_QMAKE_INCLUDES@
 USE_CORBA = @QT_USE_CORBA@
 
-PLOTLIBS = -lqwt@with_qwt_suffix@ -L../../OMPlot/bin/ -lOMPlot
-PLOTINC = @with_qwt@ ../../OMPlot/OMPlotGUI
+QMAKEFEATURES += @with_qwt@/features
+CONFIG += qwt
+
+PLOTLIBS = -F@with_qwt@/lib/ -framework qwt -L../../OMPlot/bin/ -lOMPlot
+PLOTINC = @with_qwt@/lib/qwt.framework/Headers ../../OMPlot/OMPlotGUI
 
 QMAKE_LFLAGS += @LDFLAGS@
+
diff --git a/OMPlot/OMPlotGUI/OMPlotGUI.config.in b/OMPlot/OMPlotGUI/OMPlotGUI.config.in
index c9f2c57..73c70bc 100644
--- a/OMPlot/OMPlotGUI/OMPlotGUI.config.in
+++ b/OMPlot/OMPlotGUI/OMPlotGUI.config.in
@@ -2,5 +2,9 @@ QMAKE_CC  = @CC@
 QMAKE_CXX = @CXX@
 QMAKE_LINK = @CXX@
 
-LIBS += -lqwt@with_qwt_suffix@
-INCLUDEPATH += @with_qwt@
+QMAKEFEATURES += @with_qwt@/features
+CONFIG += qwt
+LIBS += -F@with_qwt@/lib/ -framework qwt
+INCLUDEPATH += @with_qwt@/lib/qwt.framework/Headers
+
+
