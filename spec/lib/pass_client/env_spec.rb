require 'pass_client/env'

RSpec.describe PassClient::Env do
  describe '.env' do
    before do
      @saved_env = ENV['PASS_CLIENT_ENV']
    end

    after  { ENV['PASS_CLIENT_ENV'] = @saved_env }

    context 'when the ENV varaible is set' do
      let(:client_env) { described_class.env }

      it 'converts the value to a symbol' do
        ENV['PASS_CLIENT_ENV'] = 'testing'

        expect(client_env).to eq(:testing)
      end

      it 'converts the value to lowercase' do
        ENV['PASS_CLIENT_ENV'] = 'TeStiNG'

        expect(client_env).to eq(:testing)
      end
    end
  end
end
