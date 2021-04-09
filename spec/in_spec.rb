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
    it 'downloads the file and produces metadata with only sha1 available' do
      response = get('cloudfoundry/os-conf-release', '16')

      file = File.join(destination, 'release.tgz')
      expect(File.exists?(file)).to be true
      expect(Digest::SHA1.hexdigest File.read(file)).to eq '8eeb72421ec94f2f9aedc50554b899d383e1d9a2'

      expect(response['metadata']).to eq [
        {"name" => "url", "value" => "https://bosh.io/d/github.com/cloudfoundry/os-conf-release?v=16"},
        {"name" => "sha1", "value" => "8eeb72421ec94f2f9aedc50554b899d383e1d9a2"}
      ]
    end
    it 'downloads the file and produces metadata with sha1 and sha256 available' do
      response = get('cloudfoundry/os-conf-release', '20')

      file = File.join(destination, 'release.tgz')
      expect(File.exists?(file)).to be true
      expect(Digest::SHA1.hexdigest File.read(file)).to eq '42b1295896c1fbcd36b55bfdedfe86782b2c9fba'
      expect(Digest::SHA256.hexdigest File.read(file)).to eq '05b99381a231cc4de54cabf6134bef75ab85aa851173f337f47c644c33f95238'

      expect(response['metadata']).to eq [
        {"name" => "url", "value" => "https://bosh.io/d/github.com/cloudfoundry/os-conf-release?v=20"},
        {"name" => "sha1", "value" => "42b1295896c1fbcd36b55bfdedfe86782b2c9fba"},
        {"name" => "sha256", "value" => "05b99381a231cc4de54cabf6134bef75ab85aa851173f337f47c644c33f95238"}
      ]
    end
  end
end
