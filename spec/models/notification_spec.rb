require 'json'
require 'omnikassa2/models/access_token'
require 'timecop'
require 'time'

describe Omnikassa2::Notification do
  AUTHENTICATION_TOKEN = 'eyJraWQiOiJOTyIsImFsZyI6IkVTMjU2In0.eyJubyMiOjEyMywibWtpZCI6NSwibm8kIjoibWVyY2hhbnQub3JkZXIuc3RhdHVzLmNoYW5nZWQiLCJjaWQiOiJhYmNkLTEyMzQiLCJleHAiOjE0ODg0NjQ1MDN9.MEUCIHtPFoKmXAc7JNQjj0U5rWpl0zR9RsQvgj_nckHBngHAiEAmbtgrxaiy4cS3BTHd0DJ8md3Rn7V13Nv35m5DurY1wI'
  SIGNATURE_HASH = '80199f65fc0432dc3ee2ab2ee0a54554c34e297d202c93b612d952355619c9cb5501d6c00e8ad235d8c4312bca8c3f26eb52cfa3307b6044e43979c6007dba97'

  base_params = {
    authentication: AUTHENTICATION_TOKEN,
    expiry: Time.parse('2016-11-25T09:53:46.000+01:00'),
    event_name: 'merchant.order.status.changed',
    poi_id: 123,
    signature: SIGNATURE_HASH
  }

  context 'when creating from JSON' do
    subject {
      Omnikassa2::Notification.from_json(
        JSON.generate(
          authentication: base_params[:authentication],
          expiry: base_params[:expiry],
          eventName: base_params[:event_name],
          poiId: base_params[:poi_id],
          signature: base_params[:signature]
        )
      )
    }

    it 'stores authentication as string' do
      expect(subject.authentication).to eq(AUTHENTICATION_TOKEN)
    end

    it 'stores expiry as DateTime' do
      expect(subject.expiry).to eq(
        Time.parse('2016-11-25T09:53:46.000+01:00')
      )
    end

    it 'stores event_name as string' do
      expect(subject.event_name).to eq('merchant.order.status.changed')
    end

    it 'stores poi_id as integer' do
      expect(subject.poi_id).to eq(123)
    end

    it 'stores signature as string' do
      expect(subject.signature).to eq(SIGNATURE_HASH)
    end
  end

  describe 'signature_valid?' do
    context 'when signature is valid' do
      subject { Omnikassa2::Notification.new(base_params) }

      it 'returns true' do
        expect(subject.valid_signature?).to eq(true)
      end
    end

    context 'when signature is not valid' do
      subject do
        Omnikassa2::Notification.new(
          base_params.merge(
            signature: 'invalidSignature'
          )
        )
      end

      it 'returns false' do
        expect(subject.valid_signature?).to eq(false)
      end
    end
  end

  describe 'expiring?' do
    before do
      Timecop.freeze Time.parse('2016-11-24T17:30:00.000+0000')
    end

    context 'when expiry date is at least 5 minutes from now' do
      subject {
        Omnikassa2::Notification.new(
          base_params.merge(
            expiry: Time.parse('2016-11-24T17:45:00.000+0000')
          )
        )
      }

      it 'returns false' do
        expect(subject.expiring?).to eq(false)
      end
    end

    context 'when expiry date is less than 30 seconds from now' do
      subject {
        Omnikassa2::Notification.new(
          base_params.merge(
            expiry: Time.parse('2016-11-24T17:30:29.000+0000')
          )
        )
      }

      it 'returns true' do
        expect(subject.expiring?).to eq(true)
      end
    end

    context 'when expiry date is in the past' do
      subject {
        Omnikassa2::Notification.new(
          base_params.merge(
            expiry: Time.parse('2016-11-24T17:25:00.000+0000')
          )
        )
      }

      it 'returns true' do
        expect(subject.expiring?).to eq(true)
      end
    end
  end
end
