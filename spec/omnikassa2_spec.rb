# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Omnikassa2 do
  describe '.config' do
    it 'has default open_timeout and read_timeout' do
      expect(Omnikassa2.config.open_timeout).to eq(30)
      expect(Omnikassa2.config.read_timeout).to eq(30)
    end
  end

  describe '.configure' do
    it 'yields the config object' do
      yielded = nil
      Omnikassa2.configure do |c|
        yielded = c
      end
      expect(yielded).to eq(Omnikassa2.config)
    end

    it 'allows changing configuration values' do
      Omnikassa2.configure do |c|
        c.open_timeout = 60
        c.read_timeout = 120
      end

      expect(Omnikassa2.config.open_timeout).to eq(60)
      expect(Omnikassa2.config.read_timeout).to eq(120)
    end

    it 'does not allow replacing the config object' do
      expect { Omnikassa2.config = Omnikassa2::Configuration.new }.to raise_error(NoMethodError)
    end
  end

  describe '.reset!' do
    before do
      Omnikassa2.configure do |c|
        c.open_timeout = 60
        c.read_timeout = 120
      end
    end

    it 'resets configuration to default values' do
      Omnikassa2.reset!

      expect(Omnikassa2.config.open_timeout).to eq(30)
      expect(Omnikassa2.config.read_timeout).to eq(30)
    end

    it 'provides a fresh Config object' do
      old_config = Omnikassa2.config
      Omnikassa2.reset!
      expect(Omnikassa2.config).not_to eq(old_config)
    end
  end
end
