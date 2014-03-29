#!/usr/bin/env ruby

require './conway'

# Examples from the wiki page

# Blinker (period 2)
def blinker
  conway = Conway.new(5, 5)

  conway.revive(2, 1)
  conway.revive(2, 2)
  conway.revive(2, 3)

  (1..10).each do |step|
    conway.step
    sleep(1)
  end
end

# Toad (period 2)
def toad
  conway = Conway.new(6, 6)

  conway.revive(2, 2)
  conway.revive(2, 3)
  conway.revive(2, 4)
  conway.revive(3, 1)
  conway.revive(3, 2)
  conway.revive(3, 3)

  (1..10).each do |step|
    conway.step
    sleep(1)
  end
end

blinker
toad