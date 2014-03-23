require "spec_helper"
require "pathname"
require_relative "../../lib/middleman-webp/converter"

describe Middleman::WebP::Converter do
  before do
    @converter = Middleman::WebP::Converter.new(nil, {}, nil)
  end

  describe "#change_percentage" do
    it "returns how many percents smaller destination file is" do
      src = stub(:size => 10000)
      dst = stub(:size => 8746)
      @converter.change_percentage(src, dst).must_equal "12.54 %"
    end

    it "omits zeroes in the end of decimal part" do
      src = stub(:size => 100)
      dst = stub(:size => 76)
      @converter.change_percentage(src, dst).must_equal "24 %"
    end
  end

  describe "#number_to_human_size" do
    it "uses human readable unit" do
      @converter.number_to_human_size(100).must_equal "100 B"
      @converter.number_to_human_size(1234).must_equal "1.21 KiB"
      @converter.number_to_human_size(2_634_234).must_equal "2.51 MiB"
    end
  end

  describe "#tool_for" do
    it "uses gif2webp for gif files" do
      path = Pathname.new("/some/path/image.gif")
      @converter.tool_for(path).must_equal "gif2webp"
    end

    it "uses cwebp for jpeg, png and tiff files" do
      path = Pathname.new("/some/path/image.jpg")
      @converter.tool_for(path).must_equal "cwebp"
      path = Pathname.new("/some/path/image.png")
      @converter.tool_for(path).must_equal "cwebp"
      path = Pathname.new("/some/path/image.tiff")
      @converter.tool_for(path).must_equal "cwebp"
    end
  end
end
