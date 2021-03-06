module ZBX
  # zabbix entity class
  # e.g. host, group, item, graph ...

  class Entity
    # entitiy name, zapix object
    # if block is given, it will be evaluated in this object
    # so the following expression is the same
    #
    # host.get(hostids: 1)
    #
    # host do
    #   get hostids: 1
    # end

    def initialize entity, parent, &b
      @entity = entity
      @parent = parent
      Util.call_block(self, &b) if block_given?
    end

    def method_missing m, arg={}
      @parent.request  "#{@entity}.#{m}", arg
    end

  end
end
