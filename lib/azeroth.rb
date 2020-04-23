# frozen_string_literal: true

require 'sinclair'

# @api public
#
# Lib for easily developing controllers
#
# @example (see Resourceable)
#
# @see Resourceable
module Azeroth
  autoload :Decorator,            'azeroth/decorator'
  autoload :Exception,            'azeroth/exception'
  autoload :Model,                'azeroth/model'
  autoload :RequestHandler,       'azeroth/request_handler'
  autoload :Resourceable,         'azeroth/resourceable'
  autoload :ResourceBuilder,      'azeroth/resource_builder'
  autoload :RoutesBuilder,        'azeroth/routes_builder'
  autoload :Options,              'azeroth/options'
end
