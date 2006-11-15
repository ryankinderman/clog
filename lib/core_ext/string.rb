module StringExtension
  def underscore
    new_str = ''
    (0..(self.size - 1)).each do |i|
      chr = self[i].chr
      if ('A'..'Z').include?(chr)
        new_str << '_' + chr.downcase
      else
        new_str << chr
      end
    end
    new_str
  end
end
String.send :include, StringExtension