#!/usr/bin/env ruby
# Model::TestFreeTextContainer -- xmlconv2 -- 29.06.2004 -- hwyss@ywesee.com

$: << File.dirname(__FILE__)
$: << File.expand_path('../../src', File.dirname(__FILE__))

require 'test/unit'
require 'model/invoice_item'

module XmlConv
	module Model
		class Container 
			include FreeTextContainer
		end
		class TestFreeTextContainer < Test::Unit::TestCase
			def setup
				@container = Container.new
			end
			def test_attr_readers
				assert_respond_to(@container, :free_text)
			end
			def test_add_free_text
				txt = @container.add_free_text('Description', 'Foo, Bar and Baz')
				assert_instance_of(FreeText, @container.free_text)
				assert_equal(@container.free_text, txt)
				assert_equal('Foo, Bar and Baz', txt)
				assert_equal('Description', txt.type)
			end
		end
		class TestFreeText < Test::Unit::TestCase
			def setup
				@text = FreeText.new
			end
			def test_append
				assert_equal('', @text)
				@text << "Foo, Bar and Baz"
				assert_equal('Foo, Bar and Baz', @text)
				@text << "with a newline"
				assert_equal("Foo, Bar and Baz\nwith a newline", @text)
				@text << ""
				assert_equal("Foo, Bar and Baz\nwith a newline", @text)
			end
		end
	end
end
