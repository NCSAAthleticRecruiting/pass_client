RSpec.describe PassClient do
  it 'has a version number' do
    expect(PassClient::VERSION).not_to be nil
    expect(PassClient::VERSION.kind_of?(String)).to be_truthy
  end
end
