#!/usr/bin/env ruby

require_relative 'lib/game'

p1 = Player.new(:white)
p2 = Player.new(:black)
g  = Game.new(p1, p2)
g.play
