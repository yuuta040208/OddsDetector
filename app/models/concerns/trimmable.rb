# frozen_string_literal: true

module Trimmable
  def trim(text)
    text.gsub(/(^[[:space:]]+)|([[:space:]]+$)/, '')
  end

  def trim_all(text)
    text.gsub(/[[:space:]]/, '')
  end
end
