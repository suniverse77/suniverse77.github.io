#!/usr/bin/env ruby
#
# Short syntax for coloured text in posts.
#
#   ==text==              highlighter pen, yellow (the default)
#   =={red}text==         highlighter pen in a named colour
#   %%{red}text%%         text colour (a colour name is required)
#
# Highlighter names: HIGHLIGHT_COLORS below. Text colour names: TEXT_COLORS below.
# The colours themselves are defined once, in assets/css/jekyll-theme-chirpy.scss
# (search for "Highlighter pen" and "Text colour"). To add a colour, add its name
# to the list here and its value to the matching list in that stylesheet.
# A name that is not in the list is left exactly as written.
#
# Fenced code blocks, `inline code` and math ($...$, $$...$$) are never touched,
# so `torch==2.1.0` or an equation containing == stays as is. Code blocks written
# by indenting four spaces are NOT recognised (indented text is usually a paragraph
# inside a list here), so put code that contains == or %% in a fenced block.

module InlineColorSyntax
  HIGHLIGHT_COLORS = %w[yellow red purple blue ivory gray green].freeze
  HIGHLIGHT_DEFAULT = 'yellow'
  TEXT_COLORS = %w[
    red green blue violet gold orange lightgreen yellowgreen
    yellow skyblue pink indigo gray brown blueviolet
  ].freeze

  HIGHLIGHT = /==(?:\{([a-z]+)\})?([^=\s](?:[^\n]*?[^=\s])?)==(?!=)/
  TEXT_COLOR = /%%\{([a-z]+)\}([^%\s](?:[^\n]*?[^%\s])?)%%/
  # parts of a line that must be left alone: inline code, then inline/display math
  PROTECTED = /(`+[^`\n]*`+|\$\$[^\n]*?\$\$|\$[^$\n]+\$)/
  FENCE = /\A {0,3}(`{3,}|~{3,})\s*[\w+-]*\s*\z/
  MATH_BLOCK = /\A\s*\$\$\s*\z/

  module_function

  def mark(text)
    # text colour first, so it can sit inside a highlight: ==%%{red}text%%==
    text = text.gsub(TEXT_COLOR) do |match|
      color = Regexp.last_match(1)
      body = Regexp.last_match(2)
      next match unless TEXT_COLORS.include?(color)

      %(<span class="tc tc-#{color}">#{body}</span>)
    end

    text.gsub(HIGHLIGHT) do |match|
      color = Regexp.last_match(1) || HIGHLIGHT_DEFAULT
      body = Regexp.last_match(2)
      next match unless HIGHLIGHT_COLORS.include?(color)

      %(<span class="hl hl-#{color}">#{body}</span>)
    end
  end

  def process(content)
    in_code = false
    in_math = false

    content.each_line.map do |line|
      if line.match?(FENCE)
        in_code = !in_code
        line
      elsif in_code
        line
      elsif line.match?(MATH_BLOCK)
        in_math = !in_math
        line
      elsif in_math
        line
      else
        # swap code and math for placeholders so coloured text may contain them
        kept = []
        masked = line.gsub(PROTECTED) do |part|
          kept << part
          "\u0000#{kept.size - 1}\u0000"
        end
        mark(masked).gsub(/\u0000(\d+)\u0000/) { kept[Regexp.last_match(1).to_i] }
      end
    end.join
  end
end

Jekyll::Hooks.register :posts, :pre_render do |post|
  post.content = InlineColorSyntax.process(post.content)
end
