require 'title_case'

class String
  include TitleCase
end

if __FILE__ == $0
  require 'test/unit'
  class TitleCaseTest < Test::Unit::TestCase

    def test_title_casing
      assert_equal("The Big Rabbit", "the big rabbit".titlecase)
      assert_equal("Apple vs. Microsoft", "apple vs. microsoft".titlecase)
      assert_equal("iTunes Is Amazing", "iTunes is amazing".titlecase)
      assert_equal("del.icio.us Steals Hearts",
        "del.icio.us steals hearts".titlecase)
      assert_equal("AT&T Fires CEO", "AT&T fires CEO".titlecase)
      assert_equal("Q&A with Bob", "Q&A with bob".titlecase)
      assert_equal("Q&A&Z with Bob", "Q&A&Z with bob".titlecase)
      assert_equal("Kids: A Primer", "kids: a primer".titlecase)
      assert_equal("Q&A with Steve Jobs: 'That's What Happens in Technology'",
        "Q&A With Steve Jobs: 'That's What Happens In Technology'".titlecase)
      assert_equal("What Is AT&T's Problem?",
        "What Is AT&T's Problem?".titlecase)
      assert_equal("Apple Deal with AT&T Falls Through",
        "apple deal with AT&T falls through".titlecase)
      assert_equal("This v. That", "this v. that".titlecase)
      assert_equal("This vs. That", "this vs. that".titlecase)
      assert_equal("The SEC's Apple Probe: What You Need to Know",
        "the SEC's apple probe: what you need to know".titlecase)
      assert_equal(%(Sub-Phrase with Small Word in Quotes: 'a Trick, Perhaps?'),
        %(Sub-Phrase With Small Word in Quotes: 'a Trick, Perhaps?').titlecase)
      assert_equal(%("Nothing to Be Afraid of?"),
        %("nothing to be afraid of?").titlecase)
      assert_equal("A Thing", "a thing".titlecase)
    end

  end
end
