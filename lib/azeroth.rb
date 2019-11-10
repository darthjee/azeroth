# frozen_string_literal: true

# @api public
#
# Lib for easily developing controllers
#
# @see Resourceable
module Azeroth
  autoload :Decorator,            'azeroth/decorator'
  autoload :Model,                'azeroth/model'
  autoload :Resourceable,         'azeroth/resourceable'
  autoload :ResourceBuilder,      'azeroth/resource_builder'
  autoload :ResourceRouteBuilder, 'azeroth/resource_route_builder'
  autoload :RoutesBuilder,        'azeroth/routes_builder'
  autoload :Options,              'azeroth/options'
end
