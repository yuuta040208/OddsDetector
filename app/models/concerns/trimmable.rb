# frozen_string_literal: true

module Trimmable
  def trim(text)
    text.gsub(/(^[[:space:]]+)|([[:space:]]+$)/, '')
  end
end
