require 'spec_helper'
describe 'pentaho' do
  context 'with default values for all parameters' do
    it { should contain_class('pentaho') }
  end
end
