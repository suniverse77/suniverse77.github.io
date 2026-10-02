#!/usr/bin/env ruby
#
# Resolve and size post images automatically.
#
# 1. An image written with only its file name, `![alt](Linux_CLI-3.png)`, is looked
#    up in the image folder that mirrors the post's own folder:
#
#      _posts/Programming/Dev_Environment/2026-01-01-Linux_CLI.md
#        -> /assets/images/Programming/Dev_Environment/Linux_CLI-3.png
#
#    Paths starting with `/` and full URLs are used as they are.
#
# 2. Every image gets a width from its aspect ratio:
#
# A Markdown image written as plain `![alt](/assets/images/...)` gets a centred
# style whose width depends on the image's shape:
#
#   width % = 52 * (width / height) ^ 0.4, limited to 25..100, rounded to a multiple of 5
#
# so wide figures take most of the column and tall ones stay narrow. The image is
# also never shown taller than MAX_HEIGHT px or wider than its real pixel width.
#
# To size one image by hand, write the style yourself right after it, e.g.
#   ![alt](/assets/images/a.png){: style="display:block; margin:0 auto; width:40%;"}
# Any image followed by `{:` is left untouched.

require 'cgi'

module ImageAutoWidth
  SCALE = 52.0
  EXPONENT = 0.4
  MIN_WIDTH = 25
  MAX_WIDTH = 100
  STEP = 5
  MAX_HEIGHT = 600 # px
  FALLBACK_WIDTH = 70 # % when the file is missing or its size cannot be read

  IMAGE = /!\[[^\]]*\]\(\s*([^)]+?)\s*\)(?!\{:)/
  # an opening or closing code fence: ``` or ~~~ with at most a language name after it
  FENCE = /\A {0,3}(`{3,}|~{3,})\s*[\w+-]*\s*\z/

  module_function

  # Pixel size of a PNG, GIF, WebP or JPEG file (by content, not extension), or nil.
  def dimensions(path)
    File.open(path, 'rb') do |file|
      head = file.read(30)
      return nil if head.nil? || head.bytesize < 30

      if head.start_with?("\x89PNG\r\n\x1A\n".b)
        return head[16, 8].unpack('NN')
      elsif head.start_with?('GIF8'.b)
        return head[6, 4].unpack('vv')
      elsif head.start_with?('RIFF'.b) && head[8, 4] == 'WEBP'.b
        case head[12, 4]
        when 'VP8 '.b
          return head[26, 4].unpack('vv').map { |v| v & 0x3FFF }
        when 'VP8L'.b
          bits = head[21, 4].unpack1('V')
          return [(bits & 0x3FFF) + 1, ((bits >> 14) & 0x3FFF) + 1]
        when 'VP8X'.b
          width = (head[24, 3] + "\x00".b).unpack1('V') + 1
          height = (head[27, 3] + "\x00".b).unpack1('V') + 1
          return [width, height]
        end
      elsif head.start_with?("\xFF\xD8".b)
        file.seek(2)
        loop do
          marker = file.read(4)
          return nil if marker.nil? || marker.bytesize < 4

          byte, code, length = marker.unpack('CCn')
          return nil unless byte == 0xFF

          # SOF0..SOF15 hold the frame size, except DHT (C4), JPG (C8) and DAC (CC)
          if code.between?(0xC0, 0xCF) && ![0xC4, 0xC8, 0xCC].include?(code)
            height, width = file.read(5).unpack('xnn')
            return [width, height]
          end
          file.seek(length - 2, IO::SEEK_CUR)
        end
      end
    end
    nil
  rescue StandardError
    nil
  end

  def style_for(site, src)
    local = File.join(site.source, CGI.unescape(src.sub(%r{\A/}, '')))
    width, height = dimensions(local) if File.file?(local)

    unless width && height && height.positive?
      return "display:block; margin:0 auto; width:#{FALLBACK_WIDTH}%;"
    end

    ratio = width.to_f / height
    percent = (SCALE * (ratio**EXPONENT) / STEP).round * STEP
    percent = percent.clamp(MIN_WIDTH, MAX_WIDTH)
    max_width = [width, (MAX_HEIGHT * ratio).round].min

    "display:block; margin:0 auto; width:#{percent}%; max-width:#{max_width}px;"
  end

  def process(site, content, folder = '')
    in_code = false

    content.each_line.map do |line|
      if line.match?(FENCE)
        in_code = !in_code
        next line
      end
      next line if in_code

      line.gsub(IMAGE) do |image|
        src = Regexp.last_match(1)
        next image if src.match?(%r{\A(?:[a-z][a-z0-9+.-]*:|//|#)}i)

        unless src.start_with?('/')
          name = src
          src = File.join('/assets/images', folder, name)
          image = image.sub(/\(\s*#{Regexp.escape(name)}\s*\)\z/) { "(#{src})" }
          unless File.file?(File.join(site.source, CGI.unescape(src)))
            Jekyll.logger.warn 'Image not found:', "#{name} (expected at #{src})"
          end
        end

        %(#{image}{: style="#{style_for(site, src)}"})
      end
    end.join
  end
end

Jekyll::Hooks.register :posts, :pre_render do |post|
  folder = File.dirname(post.relative_path).sub(%r{\A_posts/?}, '')
  post.content = ImageAutoWidth.process(post.site, post.content, folder)
end
