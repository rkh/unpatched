require 'unpatched'

describe Unpatched do
  before { extend Unpatched }
  it 'should not fail me' do
    exactly(2).seconds.should == 2
    exactly(2).minutes.should == 120
    about(10).minutes.and(1).second.should == 601
    _('FooBar').underscore.should == 'foo_bar'
    about(10).minutes.ago!.should be_a(Time)
    about(10).minutes.from_now!.should be_a(Time)
    exactly(10).before(12).should == 2
  end
end
