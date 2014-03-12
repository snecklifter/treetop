module Treetop
  module Compiler    
    class Terminal < AtomicExpression
      def compile(address, builder, parent_expression = nil)
        super
	insensitive = insens.text_value.length > 0
	str = insensitive ? string : string.downcase
        string_length = eval(str).length

        builder.if__ "has_terminal?(#{str}, #{insensitive ? ':insens' : false}, index)" do
          if address == 0 || decorated? || string_length > 1
	    assign_result "instantiate_node(#{node_class_name},input, index...(index + #{string_length}))"
	    extend_result_with_inline_module
          else
            assign_lazily_instantiated_node
	  end
          builder << "@index += #{string_length}"
        end
        builder.else_ do
          builder << "terminal_parse_failure(#{str})"
          assign_result 'nil'
        end
      end
    end
  end
end
