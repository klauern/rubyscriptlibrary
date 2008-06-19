# See "An Approach to Composing Domain-Specific Languages in Ruby":
# http://weblog.raganwald.com/2007/03/approach-to-composing-domain-specific.html
#
#  Created by Reginald Braithwaite on 2007-03-11.
#  Copyright (c) 2007. All rights reserved.
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
# 
# Copyright (C) 2004 Sam Hocevar
#  22 rue de Plaisance, 75014 Paris, France
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
# 
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
# 
#  0. You just DO WHAT THE FUCK YOU WANT TO.
	
# A Domain Specific Language is used to introduce a new scope with an embedded set of methods.
#
# The idea is to avoid polluting the global namespace. Instead of adding methods to Kernel, we
# add methods to a new DomainSpecificLanguage, and then we can evaluate code with the new language
# using the #eval class method or using the #with method added to Kernel.
#
# For a similar approach, see http://www.infoq.com/articles/eval-options-in-ruby
	
class DomainSpecificLanguage

  # See http://whytheluckystiff.net/articles/seeingMetaclassesClearly.html
	
  def metaclass; class << self; self; end; end
  def meta_eval &blk; metaclass.instance_eval &blk; end

  # Adds methods to a metaclass
  def meta_def name, &blk
    meta_eval { define_method name, &blk }
  end

  # See http://onestepback.org/index.cgi/Tech/Ruby/RubyBindings.rdoc
	  
  class ReadOnlyReference
    def initialize(var_name, vars)
      @getter = eval "lambda { #{var_name} }", vars
    end
    def value
      @getter.call
    end
  end

  attr_reader :outer_binding, :outer_self

  # instances of a DomainSpecificLanguage are created each time
  # a block is evaluated with that language. The instance is
  # intialized with the block's binding.
	  
  def initialize(given_binding)
    @outer_binding = given_binding
    @outer_self = ReadOnlyReference.new(:self, given_binding)
  end

  # some jiggery-pokery to access methods defined in the block's
  # scope, because when the block is evaluated with the DomainSpecificLanguage,
  # we use #instance_eval to set <tt>self</tt> to the DomainSpecificLanguage
  # instance.
  def method_missing(symbol, *args, &block)
    if args.empty?
      r = ReadOnlyReference.new(symbol, outer_binding)
      meta_def(symbol) { r.value }
      r.value
    else
      outer_self.value.send symbol, *args, &block
    end
  end

  class << self

    # Evaluates a block in the context of a new DomainSpecificlanguage
    # instance.
    def eval &block
      new(block.binding).instance_eval(&block)
    end

  end

end

# We open Kernel and add just one method for introducing DomainSpecificLanguages
	
module Kernel

  # Evaluate a block with a DomainSpecificLanguage
	  
  def with dsl_class, &block
    dsl_class.eval(&block)
  end

end

# Let is a DomainSpecificLanguage that actually creates DomainSpecificLanguages.
#
# Let works a lot like <tt>let</tt> in Scheme. Your provide a hash of names and value
# expressions. The value expressions are evaluated in the outer scope, and then we have
# a little domain specific language wher ethe inner scope has the names all bound to the
# values. E.g.
# <tt>
# with Let do
#     let :x => 100, :y => 50 do
#         print "#{x + y} should equal fifty"
#     end
# end
# </tt>
#
# Within the Let DomainSpecificLanguage, you can declare multiple <tt>let</tt> statements and nest
# them as you please.
#
# One important limitation: you cannot bind a value to a name that is already a local variable.
	
class Let < DomainSpecificLanguage

  class Scope < DomainSpecificLanguage

    # initializes a Scope. In addition to the outer binding, we also pass in the
    # hash of names and values. Note the check to ensure we are not trying to
    # override a lcoal variable.
	    
    def initialize given_binding, let_clauses = {}
      let_clauses.each do |symbol, value| 
        var_name = symbol.to_s
        raise ArgumentError.new("Cannot override local #{var_name}") if eval("local_variables", given_binding).detect { |local| local == var_name  }
        meta_eval { attr_accessor(var_name) }
        send "#{var_name}=", value
      end
      super(given_binding)
    end

  end

  # Define a new Scope: you're really defining a new DomainSpecificLanguage
	  
  def let let_clauses = {}, &block
    Scope.new(block.binding, let_clauses).instance_eval(&block)
  end

  class << self

    # If you just want a one-off
    # def eval let_clauses = {}, &block
    #   Scope.new(block.binding, let_clauses).instance_eval(&block)
    # end
	    
  end

end

# A DomainSpecificDelegator is a DSL that delegates methods to a class or object.
# The main use is to separate the mechanics of scoping from the methods of a utility
# class.
	
class DomainSpecificDelegator < DomainSpecificLanguage

  class << self

    # insert one or more #delegate_to calls in the class definition, giving a receiver
    # and a hash. Each hash pair is of the form <tt>verb => method</tt> where verb is the
    # name you will use in the DSL and method is the method in the receiver that will handle
    # it.
    def delegate_to receiver, method_hash
      @@delegations ||= {}
      method_hash.each { |verb, method_name| @@delegations[verb.to_s] = [receiver, method_name.to_s] }
    end

  end

  def method_missing symbol, *args, &block
    receiver, method_name = *@@delegations[symbol.to_s]
    if receiver
      receiver.send method_name, *args, &block
    else
      super(symbol, *args, &block)
    end
  end

end
	
	

	
#!/usr/bin/env ruby
#
#  Created by Reginald Braithwaite on 2007-03-11.
#  Copyright (c) 2007. All rights reserved.
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
# 
# Copyright (C) 2004 Sam Hocevar
#  22 rue de Plaisance, 75014 Paris, France
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
# 
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
# 
#  0. You just DO WHAT THE FUCK YOU WANT TO.
	
require "test/unit"
require "dsl"

class DefinesVariable < DomainSpecificLanguage
  def y
    5
  end
end

class DefinesMethodWithBlock  < DomainSpecificLanguage
  def say something
    something
  end
end

class TestDomainSpecificLanguage < Test::Unit::TestCase

  def test_simple_read
    x = 100
    assert_equal(500, DomainSpecificLanguage.eval { x * 5 })
  end

  def test_define_reader
    x = 100
    assert_equal(500, DefinesVariable.eval { x * y })
  end

  def test_define_method
    assert_nothing_raised(Exception) { DefinesMethodWithBlock.eval { say 'hello' } }
  end

  def test_uses_lambda
    double = lambda { |x| x * 2 }
    assert_equal(8, DomainSpecificLanguage.eval { double.call(4) })
  end

  def square x
    x * x
  end

  def test_uses_method
    assert_equal(16, DomainSpecificLanguage.eval { square(4) })
  end

end

class DomainSpecificDelegatorTestHelper < DomainSpecificDelegator

  delegate_to "hello", :say => :to_s

end

class TestDomainSpecificDelegator < Test::Unit::TestCase

  def test_say
    with DomainSpecificDelegatorTestHelper do
      assert_equal('hello', say)
    end
  end

  def world
    'world'
  end

  def test_outer_scope_method
    with DomainSpecificDelegatorTestHelper do
      assert_equal('hello world', "#{say} #{world}")
    end
  end

end

class TestLet < Test::Unit::TestCase

  def test_cannot_try_to_override_locals
    with Let do
      local_var = :snafu
      assert_raise(ArgumentError) do
        let :local_var => :fubar do 
          fail();
        end
      end
    end
  end

  def test_scoping
    with Let do
      let :x => 1, :y => 2 do
        assert_equal(1, x) 
        assert_equal(2, y)
      end
    end
  end

  def test_access_to_outer_locals
    with Let do
      x = 1
      let :y => 2 do
        assert_equal(3, x + y)
      end
    end
  end

  def z
    -1
  end

  def test_access_to_outer_methods
    with Let do
      let :x => 1 do
        assert_equal(0, x + z)
      end
    end
  end

  def test_nesting
    with Let do
      let :x => 0, :y => 1 do
        assert_equal(1, x + y)
        let :x => 2 do
          assert_equal(3, x + y) 
        end
        assert_equal(0, x)
      end 
    end
  end

  def test_assignment
    with Let do
      let :x => 0, :y => 1 do
        assert_equal(1, x + y)
        let :x => 2 do
          assert_equal(3, x + y) 
          x = 5
          assert_equal(5, x)
          assert_equal(2, x()) # assignment creates a local that shadows the method.
          self.x = 7
          assert_equal(5, x)
          assert_equal(7, x()) # you can hack around the read only nature, but it's not pretty
        end
        assert_equal(0, x)
      end
    end
  end

  def test_let_and_block_parameters
    with Let do
      let :x => nil do
        (1..10).each { |x| assert !x.nil? }
        assert_nil(x)
      end
    end
  end

  attr_accessor :w

  def test_outer_assigment
    w = 5
    with Let do
      let :x => 5 do
        assert_equal(25, w * x)
        w = 7
        assert_equal(35, w * x)
      end
    end
    assert_equal(7, w)
  end

end
