require 'xliffer/xliff'
require 'nokogiri'

module XLIFFer
  class XLIFF
    class File
      attr_reader :source_language, :target_language, :original, :strings
      alias_method :file_name, :original
      def initialize(xml)
        unless xml_element?(xml) and file?(xml)
          raise ArgumentError, "can't create a File without a file subtree"
        end

        @original = xml.attr("original")
        @source_language = xml.attr("source-language")
        @target_language = xml.attr("target-language")
        if @target_language == nil || @target_language == ""
          @strings = xml.xpath('//trans-unit').map{|tu| String.new(tu, false)}
        else
          @strings = xml.xpath('//trans-unit').map{|tu| String.new(tu)}
        end
      end


      private
      # TODO: move to public method on XLIFF
      def xml_element?(xml)
        xml.kind_of? Nokogiri::XML::Element
      end

      def file?(xml)
        xml.name.downcase == "file"
      end
    end
  end
end
