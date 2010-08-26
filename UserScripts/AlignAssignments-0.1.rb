#!/usr/bin/env ruby
#
# Assignment block tidier, version 0.1.
#
# Copyright Chris Poirier 2006.
# Licensed under the Academic Free License version 3.0.
#
# Modifications copyright 2009 Nathan de Vries.
#
# Per the license, use of this script is ENTIRELY at your own risk.
# See the license for full details (they override anything I've
# said here).

#
# NOTE:
# This script was stolen shamelessly from TextMate, and modified to remove any
# TextMate specific behavior so that it works as an Xcode user script.
#
# To install:
#
# 1. Store this script somewhere convenient (e.g. ~/Library/Application Support/Developer/Shared/Xcode)
# 2. In Xcode, Open Scripts > Edit User Scripts...
# 3. Drag the script from Finder into the Code group of the user scripts panel
# 4. Set Input to "Selection", Directory to "Selection", Output to "Replace
#    Selection" and Errors to "Display in Alert"
# 5. Optionally, rename the script to "Align Assignments" and assign it to ⌥⌘]
#
# To use, highlight a block of text and select Scripts > Code > Align
# Assignments, or use the keyboard shortcut you assigned earlier
#

lines = STDIN.readlines()

relevant_line_pattern = /^[^=]+[^-+<>=!%\/|&*^]=(?!=|~)/
column_search_pattern = /[\t ]*=/


block_top    = 1
block_bottom = lines.length


#
# Now, iterate over the block and find the best column number
# for the = sign.  The pattern will tell us the position of the
# first bit of whitespace before the equal sign.  We put the
# equals sign to the right of the furthest-right one.  Note that
# we cannot assume every line in the block is relevant.

best_column = 0
block_top.upto(block_bottom) do |number|
 line = lines[number - 1]
 if line =~ relevant_line_pattern then
    m = column_search_pattern.match(line)
    best_column = m.begin(0) if m.begin(0) > best_column
 end
end


#
# Reformat the block.  Again, we cannot assume all lines in the
# block are relevant.

block_top.upto(block_bottom) do |number|
 if lines[number-1] =~ relevant_line_pattern then
    before, after = lines[number-1].split(/[\t ]*=[\t ]*/, 2)
    lines[number-1] = [before.ljust(best_column), after].join(after[0,1] == '>' ? " =" : " = ")
 end
end


#
# Output the replacement text

lines.each do |line|
 puts line
end
