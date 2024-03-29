module Seek
  module Samples
    module AttributeHandlers
      class LinkedExtendedMetadataMultiAttributeHandler < LinkedExtendedMetadataAttributeHandler

        def test_value(value)
          fail 'Not a extended metadata multi' unless value.is_a?(Array)
        end

        # Params from form are passed as a hash from controller, e.g. { "1" => { "attribute" => "value" } , "2" => ... }
        def convert(value)
          value = value.values if value.is_a?(Hash)
          value.map { |v| super(v) }
        end

      end
    end
  end
end