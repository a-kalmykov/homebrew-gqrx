require "formula"

class GrOsmosdr < Formula
  homepage "http://sdr.osmocom.org/trac/wiki/GrOsmoSDR"
  head 'git://git.osmocom.org/gr-osmosdr.git', :shallow => false,
    :revision => 'ae686c462df73285fc13d3a0dc76f360a911500b'

  depends_on "cmake" => :build
  depends_on "python"
  build.without? "python-deps"
  depends_on "gnuradio"

  def install
    mkdir "build" do
      args = std_cmake_args

      # From opencv.rb
      python_prefix = `python-config --prefix`.strip
      # Python is actually a library. The libpythonX.Y.dylib points to this lib, too.
      if File.exist? "#{python_prefix}/Python"
        # Python was compiled with --framework:
        args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
        if !MacOS::CLT.installed? and python_prefix.start_with? "/System/Library"
          # For Xcode-only systems, the headers of system's python are inside of Xcode
          args << "-DPYTHON_INCLUDE_DIR='#{MacOS.sdk_path}/System/Library/Frameworks/Python.framework/Versions/2.7/Headers'"
        else
          args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/Headers'"
        end
      else
        python_lib = "#{python_prefix}/lib/lib#{which_python}"
        if File.exist? "#{python_lib}.a"
          args << "-DPYTHON_LIBRARY='#{python_lib}.a'"
        else
          args << "-DPYTHON_LIBRARY='#{python_lib}.dylib'"
        end
        args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/include/#{which_python}'"
      end
      args << "-DPYTHON_PACKAGES_PATH='#{lib}/#{which_python}/site-packages'"

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  test do
    system "false"
  end
end
