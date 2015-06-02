require File.expand_path(File.dirname(__FILE__) + '/neo')
require 'pry'

C = "top level"

class AboutConstants < Neo::Koan

  C = "nested"

  def test_nested_constants_may_also_be_referenced_with_relative_paths
    assert_equal("nested", C)
  end

  def test_top_level_constants_are_referenced_by_double_colons
    # see in rails active record when you draw from active base
    assert_equal("top level", ::C)
  end

  def test_nested_constants_are_referenced_by_their_complete_path
    assert_equal("nested", AboutConstants::C)
    assert_equal("nested", ::AboutConstants::C)
  end

  # ------------------------------------------------------------------

  class Animal
    LEGS = 4
    def legs_in_animal
      LEGS
    end
# these are called inner classes and in oop they serve the purpose of defining a
# class which cannot be instantiated without being bound to an upper level class
# conveys a contract between the two classes and tells us more about their
# purpose
    class NestedAnimal
      def legs_in_nested_animal
        LEGS
      end
    end
  end

  def test_nested_classes_inherit_constants_from_enclosing_classes
    # because constants are global?
    assert_equal(4, Animal::NestedAnimal.new.legs_in_nested_animal)
  end

  # ------------------------------------------------------------------

  class Reptile < Animal
    #
    def legs_in_reptile
      LEGS
    end
  end

  def test_subclasses_inherit_constants_from_parent_classes
    assert_equal(4, Reptile.new.legs_in_reptile)
  end

  # ------------------------------------------------------------------

  class MyAnimals
    LEGS = 2

    class Bird < Animal
      def legs_in_bird
        LEGS
      end
    end
  end

  def test_who_wins_with_both_nested_and_inherited_constants
    # nested wins
    assert_equal(2, MyAnimals::Bird.new.legs_in_bird)
  end

  # QUESTION: Which has precedence: The constant in the lexical scope,
  # or the constant from the inheritance hierarchy?

  # ------------------------------------------------------------------

  class MyAnimals::Oyster < Animal
    def legs_in_oyster
      LEGS
    end
  end

  def test_who_wins_with_explicit_scoping_on_class_definition
    assert_equal(4, MyAnimals::Oyster.new.legs_in_oyster)
  end

  # QUESTION: Now which has precedence: The constant in the lexical
  # scope, or the constant from the inheritance hierarchy?  Why is it
  # different than the previous answer?
end
