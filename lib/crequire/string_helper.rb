module StringHelper
  def charpp(value = nil)
    if value
      Charpp.new(self, self.copy_charpp(value))
    else
      Charpp.new(self, self.new_charpp)
    end
  end

  class Charpp
    def initialize(type, pointer)
      @type = type
      @pointer = pointer
    end

    def pointer
      @pointer
    end

    def value
      type.charpp_value(@pointer)
    end

    def delete
      type.delete_charpp(@pointer)
      @pointer = nil
    end
  end
end
