# More intelligent title-casing
#
# Author: Brad Fults <bfults@gmail.com>
# Date: May 21, 2008
#
# Based on the original work of Martin DeMello:
#   http://zem.novylen.net/ruby/
# modified with an eye toward John Gruber's "Title Case" script:
#   http://daringfireball.net/2008/05/title_case
# but differentiated in several ways.
#
# This software is released under The MIT License; see LICENSE file for details.
#
# Original Author: Martin DeMello <martindemello@yahoo.com>
# Original Date: Jan 07, 2003
#
# Thanks to Janet Miles for help with the capitalization rules
#
# Reference: The Harbrace Handbook
#
# 9c. The first, last, and all major words in titles are capitalized. (See 10a
#  and 16c.)
#
# In the style favored by the Modern Language Association (MLA) and in that
# recommended by the Chicago Manual of Style (CMS), all words in titles and
# subtitles are capitalized, except articles, coordinating conjunctions,
# prepositions, and the to in infinitives (unless they are the first or last
# word). The articles are a, an, and the; the coordinating conjuctions are and,
# but, for, nor, or, so, and yet. (A list of common prepositions can be found
# in chapter 1; see page 19.) MLA style favors lowercasing all prepositions,
# including long prepositions such as before, between, and through, which
# formerly were capitalized. APA style requires capitalizing any word that has
# four or more letters, including prepositions.
#
#         * The Scarlet Letter
#         * "How to Be a Leader"
#         * From Here to Eternity
#         * "What This World Is Coming To
#         * Mean Are from Mars, Women Are from Venus [MLA and CMS]
#         * Mean Are From Mars, Women Are From Venus [APA]
#
#
# In a title, MLA, APA, and CMS recommend capitalizing all words of a
# hyphenated compound except for articles, coordinating conjunctions, and
# prepositions unless the first element of the compound is a prefix.
#
#         * "The Building of the H-Bomb" [noun]
#         * "The Arab-Israeli Dilemma" [proper adjective]
#         * "Stop-and-Go Signals" [lowercase coordinating conjunction]
#
# Because all three style manuals recommend that, in general, compounds with
# prefixes not be hyphenated except in special circumstances, the resulting
# single-word combinations follow the normal rules of capitalization. However,
# if misreading could occur (as in un-ionized or re-cover), if the second
# element begins with a capital letter (pre-Christmas), or if the compound
# results in a doubled letter that could be hard to read (anti-intellectual),
# all style manuals recommend hyphenating the compound. MLA and APA capitalize
# both elements of these compounds with prefixes, whereas CMS capitalizes only
# those elements that are proper nouns or proper adjectives. (While MLA does
# not specifically mention compounds with self-, both APA and CMS usually
# hyphenate self- compounds.)
#
#         * "Colonial Anti-Independence Poetry" [MLA]
#         * "Anti-Independence Behavior in Pre-Teens" [APA]
#         * "Anti-independence Activities of Delaware's Tories" [CMS]
#
#
# However, in titles that appear in lists of references, APA style permits
# capitalizing only the first word and any proper nouns or proper adjectives.

#    -- Hodges, John C. Hodges' Harbrace Handbook. 14th ed. Fort Worth:
# Harcourt, 2001.

require 'with_index'

module TitleCase
  # mix into String

  ARTICLES = %w(a an the)
  COORDINATING_CONJUNCTIONS = %w(and but for nor or so yet)
  COMMON_PREPOSITIONS = %w(
    about beneath in regarding above beside inside round
    across between into since after beyond like through
    against by near to among concerning of toward
    around despite off under as down on unlike
    at during out until before except outside up
    behind for over upon below from past with via
  )
  LATIN_ABBREVIATIONS = %w(v vs id est)
  TRANSITION_POINT = /[:\-*@]\s*$/
  INTERNAL_SYMBOL = /^[^\w\s'"]$/

  EXCEPTIONS = ARTICLES + COORDINATING_CONJUNCTIONS + COMMON_PREPOSITIONS
  ALWAYS_LOWER = LATIN_ABBREVIATIONS

  def icap # intelligent capitalization
    a = downcase
    if a =~ /^['"\(\[']*(\w)/
      i = a.index($1)
      a[i, 1] = a[i, 1].upcase
    end
    a
  end

  def icap!
    replace(icap)
  end

  def titlecase(exceptions = [])
    exclude = EXCEPTIONS + exceptions
    a = split(/\b/)
    b = downcase.split(/\b/)
    len = b.length
    b.map_with_index {|w, i|
      # if it already had an internal cap then leave it alone
      if a[i] =~ /^\w+[A-Z]/
        a[i]
      # if there's an internal dot, assume it's lower
      elsif b[i+1] == '.' || b[i-1] == '.'
        w
      # if there's an internal non-word symbol, leave it alone
      elsif b[i+1] =~ INTERNAL_SYMBOL || b[i-1] =~ INTERNAL_SYMBOL
        a[i]
      # always capitalize first and last words
      elsif i == 0 or i == len - 1
        w.icap
      # don't capitalize Latin and other abbreviations
      elsif ALWAYS_LOWER.include?(w) && b[i+1] =~ /^\./
        w
      # capitalize all words after a transition point
      elsif exclude.include?(w) && b[i-1] =~ TRANSITION_POINT
        w.icap
      # don't capitalize the second half of words with apostrophes
      elsif exclude.include?(w) or (i>1) && b[i-1] == "'" && b[i-2] =~ /\w/
        w
      else
        w.icap
      end
    }.join
  end
end
