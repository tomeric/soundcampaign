require 'spec_helper'

describe ContactList do
  subject(:list) { build :contact_list }
  
  it { should be_valid }
  
  context 'callbacks' do
    context 'on create' do
      let(:organization) { list.organization }
      
      it "adds the members of the list's organization as contacts" do
        member = create :user, organization: organization
        list.save
        expect(list.contacts.map(&:email)).to include member.email
      end
    end
  end
end
