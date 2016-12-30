module StoriesHelper

  def strip_lines(text)
    text.gsub(/ *\n */, "\n")
  end

  def remove_single_newline(text)
    text.gsub(/([^\n])\n([^\n])/, '\1 \2')
  end

  def remove_extra_newlines(text)
    text.gsub(/\n+/, "\n")
  end

  def split_paras(text)
    text.split("\n").map! { |para|
      content_tag(:p, raw(para)) }.join.html_safe
  end

  def story_format(text)
    text = strip_lines(text)
    text = remove_single_newline(text)
    text = remove_extra_newlines(text)
    text = italics(text)
    split_paras(text)
  end

  def italics(text)
    text.gsub(/\*(.*)\*/, '<i>\1</i>')
  end
end
