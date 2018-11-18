module PictureTag
  # This is a little module to hold logic that doesn't fit other places. If it
  # starts getting big, refactor.
  module Utils
    # Configure Jekyll to keep our generated files
    def self.keep_files
      dest_dir = PictureTag.config['picture']['destination_dir']

      # Chop a slash off the end, if it's there. Doesn't work otherwise.
      dest_dir = dest_dir[0..-2] if dest_dir =~ %r{/\z}

      return if PictureTag.site.config['keep_files'].include?(dest_dir)

      PictureTag.site.config['keep_files'] << dest_dir
    end

    # Parse a liquid template; allows liquid variables to be included as tag
    # params.
    def self.liquid_lookup(params)
      Liquid::Template.parse(params).render(PictureTag.context)

      # This gsub allows people to include template code for javascript
      # libraries such as handlebar.js. It adds complication and I'm not sure
      # it has much value now, so I'm commenting it out. If someone has a use
      # case for it we can add it back in.
      # .gsub(/\\\{\\\{|\\\{\\%/, '\{\{' => '{{', '\{\%' => '{%')
    end

    # Allows us to use 'original' as a format name.
    def self.process_format(format, media)
      if format.casecmp('original').zero?
        filename = PictureTag.source_images[media]
        File.extname(filename)[1..-1].downcase # Strip leading period
      else
        format.downcase
      end
    end
  end
end