# frozen_string_literal: true

require 'json'
require 'omnikassa2/models/access_token'
require 'timecop'
require 'time'

describe Omnikassa2::AccessToken do
  let(:base_params) do
    {
      token: 'SoMeT0KeN',
      valid_until: Time.parse('2016-11-24T17:30:00.123+0000'),
      duration_in_millis: 28_800_000
    }
  end

  context 'when creating from JSON' do
    subject do
      Omnikassa2::AccessToken.from_json(
        JSON.generate(
          token: base_params[:token],
          validUntil: '2016-11-24T17:30:00.123+0000',
          durationInMillis: base_params[:duration_in_millis]
        )
      )
    end

    it 'stores token as string' do
      expect(subject.token).to eq('SoMeT0KeN')
    end

    it 'stores validUntill as DateTime' do
      expect(subject.valid_until).to eq(
        Time.parse('2016-11-24T17:30:00.123+0000')
      )
    end

    it 'stores durationInMillis as integer' do
      expect(subject.duration_in_millis).to eq(28_800_000)
    end
  end

  describe 'expiring?' do
    before do
      Timecop.freeze Time.parse('2016-11-24T17:30:00.123+0000')
    end

    context 'when valid_until is at least 5 minutes from now' do
      subject do
        Omnikassa2::AccessToken.new(
          base_params.merge(
            valid_until: Time.parse('2016-11-24T17:45:00.000+0000')
          )
        )
      end

      it 'returns false' do
        expect(subject.expiring?).to eq(false)
      end
    end

    context 'when valid_until is less than 5 minutes from now' do
      subject do
        Omnikassa2::AccessToken.new(
          base_params.merge(
            valid_until: Time.parse('2016-11-24T17:31:00.000+0000')
          )
        )
      end

      it 'returns true' do
        expect(subject.expiring?).to eq(true)
      end
    end

    context 'when valid_until is in the past' do
      subject do
        Omnikassa2::AccessToken.new(
          base_params.merge(
            valid_until: Time.parse('2016-11-24T17:25:00.000+0000')
          )
        )
      end

      it 'returns true' do
        expect(subject.expiring?).to eq(true)
      end
    end
  end
end
