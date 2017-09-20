require 'spec_helper'
require 'json'

RSpec.describe 'check' do
  def check(repo, version = nil)
    payload = {
      source: {
        repository: repo
      },
    }

    if version
      payload[:version] = { version: version }
    end

    output = `echo '#{payload.to_json}' | /opt/resource/check`
    JSON.parse(output)
  end

  context 'when concoure has no previous versions' do
    it 'returns the most recent version' do
      versions = check('concourse/concourse')

      expect(versions.length).to eq 1
      expect(versions.first).to have_key("version")
      expect(versions.first["version"]).to match /^\d+\.\d+\.\d+$/
    end
  end

  context 'when concourse has a last known version' do
    it 'produces a list of newer versions (including the last known version)' do
      versions = check('concourse/concourse', '0.11.0')

      expect(versions.length).to be > 0
      expect(versions[0]["version"]).to eq '0.11.0'
      expect(versions[1]["version"]).to eq '0.12.0'
    end
  end

  context 'when the last know version no longer exists' do
    it 'returns the most recent version' do
      versions = check('concourse/concourse', 'unknown-version')

      expect(versions.length).to eq 1
      expect(versions.first).to have_key("version")
      expect(versions.first["version"]).to match /^\d+\.\d+\.\d+$/
    end
  end
end
