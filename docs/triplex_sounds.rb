## Copyright (c) 2026 Laurent Vincent. All rights reserved.
##
## Triplex - A Flutter-based matching game.
## Licensed under the MIT License.
## See LICENSE file in the project root for full license text.
##
## This file contains game sounds source code rendered with Sonic Pi


# Tile selected
define :tile_select do
  sample :elec_tick, rate: 1.5
end

# Time-out
define :clock do
  with_fx :gverb, mix: 0.05 do
    sample :elec_blip, amp: 1.1
  end
end

# Start/Pause/Resume
define :start do
  sample :perc_swash
end

# Restart
define :restart do
  sample :vinyl_backspin, rate: 1.5
end

# Volume off
define :volume_off do
  with_synth :beep do
    s = play 60, release: 0.5, note_slide: 0.5
    sleep 0.1
    control s, note: 20
  end
end

# Volume on
define :volume_on do
  with_synth :beep do
    s = play 40, release: 0.5, note_slide: 0.5
    sleep 0.1
    control s, note: 80
  end
end

# Good match
define :good_match do
  use_synth :piano
  notes = [:C6, :D6, :E6, :F6]
  with_fx :gverb, mix: 0.1 do
    counter = 0
    4.times do
      play notes[counter], amp: (0.2 + counter*0.3)
      counter = (inc counter)
      sleep 0.1
    end
  end
end

# Wrong match
define :wrong_match do
  with_fx :gverb, mix: 0.02 do
    sample :elec_wood, amp: 0.1
    sample :elec_bong, rate: 2, amp: 0.8
    sleep 0.2
    sample :elec_bong, rate: 0.5, amp: 0.3
  end
end

# game over 1
define :game_over do
  sample :guit_em9, rate: 1.5, amp: 0.9
end

# game over 2
define :game_over2 do
  sample :guit_e_fifths, rate: 1.5, amp: 0.9
end

live_loop :triple do
  # play tile tick
  4.times do
    tile_select
    sleep 1
  end
  
  # play clock
  4.times do
    clock
    sleep 1
  end
  
  2.times do
    start
    sleep 1
  end
  
  restart
  sleep 2
  
  volume_on
  sleep 2
  
  volume_off
  sleep 2
  
  good_match
  sleep 2
  
  
  wrong_match
  sleep 2
  
  
  game_over
  sleep 8
  
  game_over2
  sleep 8
end
