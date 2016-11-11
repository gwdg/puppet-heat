require 'spec_helper'

describe 'heat::db::mysql' do

  let :params do
    { :password     => 's3cr3t',
      :dbname       => 'heat',
      :user         => 'heat',
      :host         => 'localhost',
      :charset      => 'utf8',
      :collate      => 'utf8_general_ci',
    }
  end

  shared_examples_for 'heat mysql database' do

    context 'when omiting the required parameter password' do
      before { params.delete(:password) }
      it { expect { is_expected.to raise_error(Puppet::Error) } }
    end

    it 'creates a mysql database' do
      is_expected.to contain_openstacklib__db__mysql( params[:dbname] ).with(
        :user          => params[:user],
        :password_hash => '*58C036CDA51D8E8BBBBF2F9EA5ABF111ADA444F0',
        :host          => params[:host],
        :charset       => params[:charset],
        :collate       => 'utf8_general_ci',
      )
    end
  end

  describe "overriding allowed_hosts param to array" do
    let :params do
      {
        :password       => 'heatpass',
        :allowed_hosts  => ['localhost','%']
      }
    end

  end

  describe "overriding allowed_hosts param to string" do
    let :params do
      {
        :password       => 'heatpass2',
        :allowed_hosts  => '192.168.1.1'
      }
    end

  end

  describe "overriding allowed_hosts param equals to host param " do
    let :params do
      {
        :password       => 'heatpass2',
        :allowed_hosts  => 'localhost'
      }
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'heat mysql database'
    end
  end

end
