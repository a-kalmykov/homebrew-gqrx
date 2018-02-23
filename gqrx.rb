require "formula"

class Gqrx < Formula
  homepage "http://gqrx.dk"
  url "https://github.com/csete/gqrx/releases/download/v2.10/gqrx-sdr-2.10-src.tar.xz"
  sha256 "edefe41e39598de1da305777d1e723d94ac9580ce581252c5068d1947770d166"
 
  head "https://github.com/csete/gqrx.git"

  depends_on "pkg-config" => :build
  depends_on "gnuradio"
  depends_on "librtlsdr"
  depends_on "gr-osmosdr"
  depends_on "qt"

  def install
    args = "PREFIX=#{prefix}"
    mkdir "build" do
      system "qmake", "..", *args
      system "make"
    end
    Dir.glob("build/*.app") { |app| mv app, prefix }
  end

  test do
    system "false"
  end
end
