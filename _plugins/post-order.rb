#!/usr/bin/env ruby
#
# Order posts written on the same day with a number instead of a time.
#
#   date: 2026-02-11
#   order: 2
#
# Posts of one day are listed by `order` (1 comes first, 2 after it, ...).
# Posts without `order` come before the numbered ones, sorted by file name.
# The number is turned into minutes after midnight, so every list on the site
# (same-category list, Previous/Next, Recent Posts, category pages) follows it.

Jekyll::Hooks.register :site, :post_read do |site|
  site.posts.docs.each do |post|
    order = post.data['order'].to_i.clamp(0, 1439)
    next if order.zero?

    post.data['date'] += order * 60
  end

  site.posts.docs.sort!
end
