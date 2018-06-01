# frozen_string_literal: true

require 'moguro/version'
require 'parser/current'
require 'method_source'
require 'delegate'

# 'Easy' contract programming library for ruby
# @since 0.0.1
module Moguro
  class << self
    attr_writer :enabled

    def enabled=(bool)
      @enabled = bool
    end

    def enabled?
      @enabled ||= true
    end
  end
end

require 'moguro/values'
require 'moguro/errors'
require 'moguro/types'
require 'moguro/extractor'
require 'moguro/method_reference'
require 'moguro/caluse'
require 'moguro/contract'
require 'moguro/handler'
require 'moguro/decorator'
require 'moguro/processros'
