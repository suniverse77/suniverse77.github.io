#!/usr/bin/env ruby
#
# Short syntax for a collapsible toggle in posts.
#
#   ::: Title                 blue title (the default)
#   content (any Markdown: math, images, lists, code blocks)
#   :::
#
#   :::{red} **Proof** of the theorem
#   content
#   :::
#
# Title colours: COLORS below. The colours themselves are defined in
# assets/css/jekyll-theme-chirpy.scss (search for "Toggle"). To add one, add its
# name here and its value there. An unknown colour name leaves the block as written.
# Toggles may be nested and may be indented inside a list item; the closing `:::`
# must be on a line of its own. Lines inside fenced code blocks are not touched.

module ToggleSyntax
  COLORS = %w[blue red orange purple].freeze
  DEFAULT = 'blue'

  OPEN = /\A(\s*):::(?:\{([a-z]+)\})?[ \t]+(\S.*?)\s*\z/
  CLOSE = /\A(\s*):::\s*\z/
  FENCE = /\A {0,3}(`{3,}|~{3,})\s*[\w+-]*\s*\z/

  module_function

  def process(content)
    in_code = false
    depth = 0

    content.each_line.map do |line|
      if line.match?(FENCE)
        in_code = !in_code
        next line
      end
      next line if in_code

      if (open = line.match(OPEN)) && COLORS.include?(open[2] || DEFAULT)
        depth += 1
        indent = open[1]
        color = open[2] || DEFAULT
        next "#{indent}<details class=\"toggle toggle-#{color}\">\n" \
             "#{indent}<summary markdown=\"span\">#{open[3]}</summary>\n" \
             "#{indent}<div markdown=\"1\">\n\n"
      end

      if depth.positive? && (close = line.match(CLOSE))
        depth -= 1
        next "\n#{close[1]}</div>\n#{close[1]}</details>\n"
      end

      line
    end.join
  end
end

Jekyll::Hooks.register :posts, :pre_render do |post|
  post.content = ToggleSyntax.process(post.content)
end
