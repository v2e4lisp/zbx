module ZBX
  module Util
    extend self
    # call a block
    # if block has one arg, yield the context
    # if no arg is passed to the block, eval block in context
    def call_block(&block, context=nil)
      if block.arity == 1
        yield context
      else
        context.instance_eval &block
      end
    end

  end
end
