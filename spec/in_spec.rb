require 'spec_helper'
require 'json'
require 'tmpdir'
require 'digest'

RSpec.describe 'in' do
  let(:destination) { Dir.mktmpdir }

  def get(repo, version = nil)
    payload = {
      source: {
        repository: repo
      },
    }

    if version
      payload[:version] = { version: version }
    end

    output = `echo '#{payload.to_json}' | /opt/resource/in #{destination}`
    JSON.parse(output)
  end

  context 'when specifying a version' do
    it 'downloads the file and produces metadata' do
      response = get('cloudfoundry/os-conf-release', '16')

      file = File.join(destination, 'release.tgz')
      expect(File.exists?(file)).to be true
      expect(Digest::SHA1.hexdigest File.read(file)).to eq '8eeb72421ec94f2f9aedc50554b899d383e1d9a2'

      expect(response['metadata']).to eq [
        {"name" => "url", "value" => "https://bosh.io/d/github.com/cloudfoundry/os-conf-release?v=16"},
        {"name" => "sha1", "value" => "8eeb72421ec94f2f9aedc50554b899d383e1d9a2"}
      ]
    end
  end
end
