require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class RmlMmc < Formula
  homepage ''
  url 'file:///Users/tgu/Documents/rml.tar.gz'
  version '2.3.8'
  sha1 '2d7ca61a42bef2c59bf2c3af5c1e90aeb1e49153'

  depends_on 'mlton'
  
  def install
    ENV.j1  # if your formula's build system can't parallelize

    system "./configure", "--disable-debug", "--nosmlnj",
                          "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    system "make -C runtime" 
    system "make -C etc" 
    system "make -C compiler rml-mlton" 
    system "make -C etc install"
    system "make -C runtime install"
    system "make -C compiler install-mlton"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test rml-mmc`.
    system "false"
  end
end
