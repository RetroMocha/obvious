require_relative '../lib/obvious/contract'

describe Hash do
  describe '#has_shape?' do
    it 'should return true for a valid shape' do
      { id: 1 }.has_shape?(id: Fixnum).should be true
    end
    
    it 'should return false for an invalid shape' do
      { id: 1 }.has_shape?(id: String).should be false
    end

    it 'should retrn the invalid field if return_field flag is set' do
      { id: 1 }.has_shape?({id: String}, true).should eq [false, :id]
    end
  end
end
