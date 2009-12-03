module Paperclip
  class Attachment
    def validate_ratio options
      if @queued_for_write[:original].present?
        dimensions       = Paperclip::Geometry.from_file @queued_for_write[:original]
        ratio_dimensions = [dimensions.width, dimensions.height].sort.reverse
        ratio            = ratio_dimensions.first / ratio_dimensions.last.to_f

        min_ratio = options[:with].first
        max_ratio = options[:with].last

        { :message => options[:message] || :paperclip_ratio, :min_ratio => min_ratio, :max_ratio => max_ratio } unless options[:with].include? ratio
      end
    end

    def validate_dimensions options
      if @queued_for_write[:original].present?
        dimensions = Paperclip::Geometry.from_file @queued_for_write[:original]
        message    = options[:message] || "dimensions must be #{options[:width]}px wide by #{options[:height]}px tall"

        min_width = options[:width].first
        max_width = options[:width].last
        min_height = options[:height].first
        max_height = options[:height].last

        { :message => :paperclip_dimensions, :min_width => min_width, :max_width => max_width, :min_height => min_height, :max_height => max_height } unless (options[:width].present? and options[:width] === dimensions.width) and (options[:height].present? and options[:height] === dimensions.height)
      end
    end
    
    private

    def flush_errors #:nodoc:
      @errors.each do |error, message|
        [message].flatten.each do |m|
          if m.is_a?(Hash)
            instance.errors.add(name, m.delete(:message), m)
          else
            instance.errors.add(name, m)
          end
        end
      end
    end
  end
end


